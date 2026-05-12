# frozen_string_literal: true

RSpec.describe Mailtrap::WebhooksAPI, :vcr do
  subject(:webhooks_api) { described_class.new(account_id, client) }

  let(:account_id) { ENV.fetch('MAILTRAP_ACCOUNT_ID', 1_111_111) }
  let(:client) { Mailtrap::Client.new(api_key: ENV.fetch('MAILTRAP_API_KEY', 'local-api-key')) }

  describe '#list' do
    subject(:list) { webhooks_api.list }

    it 'maps response data to Webhook objects' do
      expect(list).to all(be_a(Mailtrap::Webhook))
    end

    context 'when api key is incorrect' do
      let(:client) { Mailtrap::Client.new(api_key: 'incorrect-api-key') }

      it 'raises authorization error' do
        expect { list }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::AuthorizationError)
          expect(error.message).to include('Incorrect API token')
        end
      end
    end
  end

  describe '#get' do
    subject(:get) { webhooks_api.get(webhook_id) }

    let(:webhook_id) { 3080 }

    it 'maps response data to Webhook object' do
      expect(get).to be_a(Mailtrap::Webhook)
      expect(get).to have_attributes(
        id: webhook_id,
        webhook_type: 'email_sending'
      )
    end

    context 'when webhook does not exist' do
      let(:webhook_id) { -1 }

      it 'raises not found error' do
        expect { get }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
        end
      end
    end
  end

  describe '#create' do
    subject(:create) { webhooks_api.create(**request) }

    let(:request) do
      {
        url: 'https://example.com/mailtrap/webhooks',
        webhook_type: 'email_sending',
        payload_format: 'json',
        sending_stream: 'transactional',
        event_types: %w[delivery bounce]
      }
    end

    it 'maps response data to Webhook object' do
      expect(create).to be_a(Mailtrap::Webhook)
      expect(create).to have_attributes(
        url: 'https://example.com/mailtrap/webhooks',
        webhook_type: 'email_sending',
        payload_format: 'json',
        sending_stream: 'transactional',
        event_types: %w[delivery bounce]
      )
      expect(create.signing_secret).not_to be_nil
    end

    context 'when invalid options are provided' do
      let(:request) { { unknown_option: true } }

      it 'raises ArgumentError' do
        expect { create }.to raise_error(ArgumentError, /invalid options are given/)
      end
    end

    context 'when API returns an error' do
      let(:request) do
        {
          url: '',
          webhook_type: 'email_sending'
        }
      end

      it 'raises a Mailtrap::Error' do
        expect { create }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
        end
      end
    end
  end

  describe '#update' do
    subject(:update) { webhooks_api.update(webhook_id, **request) }

    let(:webhook_id) { 3080 }
    let(:request) do
      {
        active: false,
        event_types: %w[delivery bounce unsubscribe]
      }
    end

    it 'maps response data to Webhook object' do
      expect(update).to be_a(Mailtrap::Webhook)
      expect(update).to have_attributes(
        id: webhook_id,
        active: false,
        event_types: %w[delivery bounce unsubscribe]
      )
    end

    context 'when invalid options are provided' do
      let(:request) { { webhook_type: 'audit_log' } }

      it 'raises ArgumentError' do
        expect { update }.to raise_error(ArgumentError, /invalid options are given/)
      end
    end

    context 'when webhook does not exist' do
      let(:webhook_id) { -1 }

      it 'raises not found error' do
        expect { update }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
        end
      end
    end
  end

  describe '#delete' do
    subject(:delete) { webhooks_api.delete(webhook_id) }

    let(:webhook_id) { 3080 }

    it 'returns deleted Webhook' do
      expect(delete).to be_a(Mailtrap::Webhook)
      expect(delete.id).to eq(webhook_id)
    end

    context 'when webhook does not exist' do
      let(:webhook_id) { -1 }

      it 'raises not found error' do
        expect { delete }.to raise_error do |error|
          expect(error).to be_a(Mailtrap::Error)
          expect(error.message).to include('Not Found')
        end
      end
    end
  end
end
