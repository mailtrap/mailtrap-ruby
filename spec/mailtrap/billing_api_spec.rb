# frozen_string_literal: true

RSpec.describe Mailtrap::BillingAPI, :vcr do
  subject(:billing_api) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }

  describe '#get' do
    subject(:get) { billing_api.get }

    it 'maps response data to Billing object' do
      expect(get).to be_a(Mailtrap::Billing)

      expect(get).to match_struct(
        billing: { cycle_start: '2026-02-06T12:59:54.000Z', cycle_end: '2026-03-06T12:59:54.000Z' },
        testing: { plan: { name: 'Team' },
                   usage: { sent_messages_count: { current: 0, limit: 5000 },
                            forwarded_messages_count: { current: 0, limit: 500 } } },
        sending: { plan: { name: 'Basic 10K' }, usage: { sent_messages_count: { current: 0, limit: 10_000 } } }
      )
    end

    context 'when api key is incorrect' do
      let(:client) { Mailtrap::Client.new(api_key: 'incorrect-api-key') }

      it 'raises authorization error' do
        expect { get }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::AuthorizationError)
          expect(error.message).to include('Incorrect API token')
          expect(error.messages.any? { |msg| msg.include?('Incorrect API token') }).to be true
        end
      end
    end
  end
end
