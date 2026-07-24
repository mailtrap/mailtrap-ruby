# frozen_string_literal: true

RSpec.describe Mailtrap::InboundMessage do
  describe '#initialize' do
    subject(:message) do
      described_class.new(
        id: '1700000000000123',
        inbox_id: 42,
        from: 'customer@example.com',
        subject: 'Re: Question',
        rfc_message_id: '<abc@example.com>',
        in_reply_to: '<orig@example.com>',
        references: ['<orig@example.com>'],
        received_at: '2026-01-15T10:30:00Z',
        thread_id: '1700000000000124',
        attachments: []
      )
    end

    it 'creates a message with all attributes' do
      expect(message).to have_attributes(
        id: '1700000000000123',
        inbox_id: 42,
        from: 'customer@example.com',
        subject: 'Re: Question',
        rfc_message_id: '<abc@example.com>',
        in_reply_to: '<orig@example.com>',
        references: ['<orig@example.com>'],
        received_at: '2026-01-15T10:30:00Z',
        thread_id: '1700000000000124',
        attachments: []
      )
    end
  end
end
