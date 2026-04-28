# frozen_string_literal: true

RSpec.describe Mailtrap::PermissionsAPI, :vcr do
  subject(:permissions_api) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }

  describe '#bulk_update' do
    subject(:bulk_update) { permissions_api.bulk_update(account_access_id, permissions) }

    let(:account_access_id) { 5339621 }
    let(:permissions) do
      [
        { resource_id: '1719941', resource_type: 'account', access_level: 'viewer' }
      ]
    end

    it 'returns the API success message' do
      expect(bulk_update).to include(message: an_instance_of(String))
    end

    context 'when account access does not exist' do
      let(:account_access_id) { -1 }

      it 'raises not found error' do
        expect { bulk_update }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end
end
