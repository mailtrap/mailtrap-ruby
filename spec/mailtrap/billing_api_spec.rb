# frozen_string_literal: true

RSpec.describe Mailtrap::BillingAPI, :vcr do
  subject(:billing) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }

  describe '#usage' do
    subject(:usage) { billing.usage }

    it 'maps response data to Billing object' do
      expect(usage).to be_a(Mailtrap::BillingUsage)

      expect(usage).to match_struct(
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
        expect { usage }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::AuthorizationError)
          expect(error.message).to include('Incorrect API token')
          expect(error.messages.any? { |msg| msg.include?('Incorrect API token') }).to be true
        end
      end
    end
  end
end
