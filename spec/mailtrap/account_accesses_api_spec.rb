# frozen_string_literal: true

RSpec.describe Mailtrap::AccountAccessesAPI, :vcr do
  subject(:account_accesses_api) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }

  describe '#list' do
    subject(:list) { account_accesses_api.list }

    it 'maps response data to AccountAccesses objects' do
      expect(list).to all(be_a(Mailtrap::AccountAccess))
    end

    context 'when api key is incorrect' do
      let(:client) { Mailtrap::Client.new(api_key: 'incorrect-api-key') }

      it 'raises authorization error' do
        expect { list }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::AuthorizationError)
          expect(error.message).to include('Incorrect API token')
          expect(error.messages.any? { |msg| msg.include?('Incorrect API token') }).to be true
        end
      end
    end
  end

  describe '#delete' do
    subject(:delete) { account_accesses_api.delete(account_access_id) }

    let(:account_access_id) { 5_190_393 }

    it 'returns deleted account access id' do
      expect(delete).to eq({ id: account_access_id })
    end

    context 'when account access does not exist' do
      let(:project_id) { 999_999 }

      it 'raises not found error' do
        expect { delete }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end
end
