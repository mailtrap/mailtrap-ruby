# frozen_string_literal: true

RSpec.describe Mailtrap::InboundAttachment do
  describe '#initialize' do
    subject(:attachment) do
      described_class.new(
        attachment_id: 'att-1',
        size: 8192,
        filename: 'report.pdf',
        content_type: 'application/pdf',
        content_disposition: 'attachment',
        content_id: nil,
        download_url: 'https://example.com/att-1',
        download_url_expires_at: '2026-01-15T10:30:00Z'
      )
    end

    it 'creates an attachment with all attributes' do
      expect(attachment).to have_attributes(
        attachment_id: 'att-1',
        size: 8192,
        filename: 'report.pdf',
        content_type: 'application/pdf',
        content_disposition: 'attachment',
        download_url: 'https://example.com/att-1',
        download_url_expires_at: '2026-01-15T10:30:00Z'
      )
    end
  end
end
