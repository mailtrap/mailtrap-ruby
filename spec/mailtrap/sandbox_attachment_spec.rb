# frozen_string_literal: true

RSpec.describe Mailtrap::SandboxAttachment do
  describe '#initialize' do
    subject(:sandbox_attachment) { described_class.new(attributes) }

    let(:attributes) do
      {
        id: 1,
        message_id: 2,
        filename: 'example.txt',
        attachment_type: 'text/plain',
        content_type: 'text/plain',
        content_id: 'content-id-123',
        transfer_encoding: 'base64',
        attachment_size: 1024,
        created_at: '2024-01-01T12:00:00Z',
        updated_at: '2024-01-02T12:00:00Z',
        attachment_human_size: '1 KB',
        download_path: '/downloads/example.txt'
      }
    end

    it 'creates a attachment with all attributes' do
      expect(sandbox_attachment).to match_struct(
        id: 1,
        message_id: 2,
        filename: 'example.txt',
        attachment_type: 'text/plain',
        content_type: 'text/plain',
        content_id: 'content-id-123',
        transfer_encoding: 'base64',
        attachment_size: 1024,
        created_at: '2024-01-01T12:00:00Z',
        updated_at: '2024-01-02T12:00:00Z',
        attachment_human_size: '1 KB',
        download_path: '/downloads/example.txt'
      )
    end
  end
end
