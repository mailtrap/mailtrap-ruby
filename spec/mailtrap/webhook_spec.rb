# frozen_string_literal: true

RSpec.describe Mailtrap::Webhook do
  describe '#initialize' do
    subject(:webhook) { described_class.new(attributes) }

    let(:attributes) do
      {
        id: 1,
        url: 'https://example.com/mailtrap/webhooks',
        active: true,
        webhook_type: 'email_sending',
        payload_format: 'json',
        sending_stream: 'transactional',
        domain_id: 435,
        event_types: %w[delivery bounce],
        signing_secret: 'a1b2c3d4e5f6'
      }
    end

    it 'creates a webhook with all attributes' do
      expect(webhook).to have_attributes(
        id: 1,
        url: 'https://example.com/mailtrap/webhooks',
        active: true,
        webhook_type: 'email_sending',
        payload_format: 'json',
        sending_stream: 'transactional',
        domain_id: 435,
        event_types: %w[delivery bounce],
        signing_secret: 'a1b2c3d4e5f6'
      )
    end
  end
end
