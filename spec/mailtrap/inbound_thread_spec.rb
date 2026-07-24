# frozen_string_literal: true

RSpec.describe Mailtrap::InboundThread do
  describe '#initialize' do
    subject(:thread) do
      described_class.new(
        id: '1700000000000124',
        subject: 'Question',
        message_count: 2,
        size: 16_384,
        first_message_at: '2026-01-15T10:00:00Z',
        last_activity_at: '2026-01-15T10:31:00Z',
        senders: ['customer@example.com'],
        recipients: ['support@company.com'],
        attachments: [],
        messages: []
      )
    end

    it 'creates a thread with all attributes' do
      expect(thread).to have_attributes(
        id: '1700000000000124',
        subject: 'Question',
        message_count: 2,
        size: 16_384,
        first_message_at: '2026-01-15T10:00:00Z',
        last_activity_at: '2026-01-15T10:31:00Z',
        senders: ['customer@example.com'],
        recipients: ['support@company.com'],
        attachments: [],
        messages: []
      )
    end
  end
end
