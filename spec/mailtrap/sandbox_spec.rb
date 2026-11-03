# frozen_string_literal: true

RSpec.describe Mailtrap::Sandbox do
  let(:attributes) do
    {
      id: 123,
      name: 'Example Sandbox',
      username: 'example-username',
      password: 'example-password',
      max_size: 123,
      status: 'active',
      email_username: 'example-email-username',
      email_username_enabled: true,
      sent_messages_count: 123,
      forwarded_messages_count: 123,
      used: true,
      forward_from_email_address: 'asd@mail.com',
      project_id: 123,
      domain: 'example.com',
      pop3_domain: 'example.com',
      email_domain: 'example.com',
      api_domain: 'example.com',
      emails_count: 123,
      emails_unread_count: 123,
      last_message_sent_at: Date.today,
      smtp_ports: 123,
      pop3_ports: 123,
      max_message_size: 123,
      permissions: {
        can_read: true,
        can_update: true,
        can_destroy: false,
        can_leave: true
      }
    }
  end

  describe '#initialize' do
    subject(:sandbox) { described_class.new(attributes) }

    it 'creates a Sandbox with all attributes' do
      expect(sandbox).to have_attributes(
        id: 123,
        name: 'Example Sandbox',
        username: 'example-username',
        password: 'example-password',
        max_size: 123,
        status: 'active',
        email_username: 'example-email-username',
        email_username_enabled: true,
        sent_messages_count: 123,
        forwarded_messages_count: 123,
        used: true,
        forward_from_email_address: 'asd@mail.com',
        project_id: 123,
        domain: 'example.com',
        pop3_domain: 'example.com',
        email_domain: 'example.com',
        api_domain: 'example.com',
        emails_count: 123,
        emails_unread_count: 123,
        last_message_sent_at: Date.today,
        smtp_ports: 123,
        pop3_ports: 123,
        max_message_size: 123,
        permissions: {
          can_read: true,
          can_update: true,
          can_destroy: false,
          can_leave: true
        }
      )
    end
  end

  describe 'deprecated Mailtrap::Inbox alias', :ruby_deprecation_warnings do
    it 'is Sandbox and warns when deprecation warnings are enabled' do
      constant = nil

      expect { constant = Mailtrap::Inbox }
        .to output(/constant Mailtrap::Inbox is deprecated/).to_stderr
      expect(constant).to be(described_class)
    end
  end
end
