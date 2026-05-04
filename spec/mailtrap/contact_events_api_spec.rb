# frozen_string_literal: true

RSpec.describe Mailtrap::ContactEventsAPI, :vcr do
  subject(:contact_events_api) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }
  let(:contact_identifier) { 'john.smith@example.com' }

  describe '#create' do
    subject(:create) { contact_events_api.create(contact_identifier, request) }

    let(:request) do
      {
        name: 'UserLogin',
        params: { user_id: 101, is_active: true }
      }
    end

    it 'maps response data to ContactEvent object' do
      expect(create).to be_a(Mailtrap::ContactEvent)
      expect(create).to have_attributes(
        contact_email: contact_identifier,
        name: 'UserLogin'
      )
    end

    context 'when invalid options are provided' do
      let(:request) { { unknown_option: true } }

      it 'raises ArgumentError' do
        expect { create }.to raise_error(ArgumentError, /invalid options are given/)
      end
    end

    context 'when name is missing' do
      let(:request) { { params: { user_id: 101 } } }

      it 'raises a Mailtrap::Error' do
        expect { create }.to raise_error(Mailtrap::Error)
      end
    end

    context 'when contact does not exist' do
      let(:contact_identifier) { 'nonexistent@example.com' }

      it 'raises not found error' do
        expect { create }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
          expect(error.messages.any? { |msg| msg.include?('Not Found') }).to be true
        end
      end
    end
  end
end
