# frozen_string_literal: true

RSpec.describe Mailtrap::ApiTokensAPI, :vcr do
  subject(:api_tokens_api) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }

  describe '#list' do
    subject(:list) { api_tokens_api.list }

    it 'maps response data to ApiToken objects' do
      expect(list).to all(be_a(Mailtrap::ApiToken))
      expect(list.first).to have_attributes(
        id: an_instance_of(Integer),
        name: an_instance_of(String),
        token: nil
      )
    end
  end

  describe '#get' do
    subject(:get) { api_tokens_api.get(token_id) }

    let(:token_id) { 2_498_561 }

    it 'maps response data to ApiToken object' do
      expect(get).to be_a(Mailtrap::ApiToken)
      expect(get).to have_attributes(
        id: token_id,
        name: an_instance_of(String),
        token: nil
      )
    end

    context 'when token does not exist' do
      let(:token_id) { -1 }

      it 'raises not found error' do
        expect { get }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end

  describe '#create' do
    subject(:create) { api_tokens_api.create(request) }

    let(:request) do
      {
        name: 'Ruby SDK Test Token',
        resources: [
          { resource_type: 'account', resource_id: account_id, access_level: 100 }
        ]
      }
    end

    it 'maps response data to ApiToken with full token value' do
      expect(create).to be_a(Mailtrap::ApiToken)
      expect(create).to have_attributes(
        id: an_instance_of(Integer),
        name: 'Ruby SDK Test Token',
        token: an_instance_of(String)
      )
    end

    context 'when invalid options are provided' do
      let(:request) { { unknown_option: true } }

      it 'raises ArgumentError' do
        expect { create }.to raise_error(ArgumentError, /invalid options are given/)
      end
    end

    context 'when name is missing' do
      let(:request) { { resources: [] } }

      it 'raises a Mailtrap::Error' do
        expect { create }.to raise_error(Mailtrap::Error)
      end
    end
  end
end
