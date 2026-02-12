# frozen_string_literal: true

RSpec.describe Mailtrap::SandboxMessage do
  subject(:sandbox_message) { described_class.new(attributes) }

  let(:attributes) do
    {
      id: 123_456,
      inbox_id: 789_012,
      subject: 'Test Subject',
      sent_at: '2024-06-01T12:00:00Z',
      from_email: 'example@mail.com',
      from_name: 'Example Sender',
      to_email: 'to@mail.com',
      to_name: 'Example Recipient',
      email_size: 2048,
      is_read: false,
      created_at: '2024-06-01T12:00:00Z',
      updated_at: '2024-06-01T12:30:00Z',
      html_body_size: 1024,
      text_body_size: 512,
      human_size: '2 KB',
      html_path: 'path/to/html',
      txt_path: 'path/to/txt',
      raw_path: 'path/to/raw',
      download_path: 'path/to/download',
      html_source_path: 'path/to/html_source',
      blacklists_report_info: true,
      smtp_information: {
        ok: true,
        data: {
          mail_from_addr: 'john@mailtrap.io',
          client_ip: '193.62.62.184'
        }
      }
    }
  end

  describe '#initialize' do
    it 'creates a sandbox_message with all attributes' do
      expect(sandbox_message).to match_struct(
        id: 123_456,
        inbox_id: 789_012,
        subject: 'Test Subject',
        sent_at: '2024-06-01T12:00:00Z',
        from_email: 'example@mail.com',
        from_name: 'Example Sender',
        to_email: 'to@mail.com',
        to_name: 'Example Recipient',
        email_size: 2048,
        is_read: false,
        created_at: '2024-06-01T12:00:00Z',
        updated_at: '2024-06-01T12:30:00Z',
        html_body_size: 1024,
        text_body_size: 512,
        human_size: '2 KB',
        html_path: 'path/to/html',
        txt_path: 'path/to/txt',
        raw_path: 'path/to/raw',
        download_path: 'path/to/download',
        html_source_path: 'path/to/html_source',
        blacklists_report_info: true,
        smtp_information: {
          ok: true,
          data: {
            mail_from_addr: 'john@mailtrap.io',
            client_ip: '193.62.62.184'
          }
        }
      )
    end
  end
end
