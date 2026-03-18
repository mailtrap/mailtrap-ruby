# frozen_string_literal: true

RSpec.describe Mailtrap::EmailLogMessage do
  let(:attributes) do
    {
      message_id: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
      status: 'delivered',
      subject: 'Welcome',
      from: 'sender@example.com',
      to: 'recipient@example.com',
      sent_at: '2025-01-15T10:30:00Z',
      client_ip: '203.0.113.42',
      category: 'Welcome Email',
      custom_variables: {},
      sending_stream: 'transactional',
      sending_domain_id: 3938,
      template_id: 100,
      template_variables: {},
      opens_count: 2,
      clicks_count: 1
    }
  end

  describe '#initialize' do
    subject(:message) { described_class.new(attributes) }

    it 'creates a message with all attributes' do
      expect(message).to have_attributes(attributes)
    end
  end
end
