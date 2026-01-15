# frozen_string_literal: true

RSpec.describe Mailtrap::Inbox do
  let(:attributes) do
    {
      id: 123,
      name: 'Example Inbox',
      username: 'example-username',
      password: 'example-password',
      max_size: 123,
      status: 'active',
      email_username: 'example-email-username',
      email_username_enabled: true,
      sent_messages_count: 123,
      forwarded_messages_count: 123,
      used: 123,
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
    subject(:inbox) { described_class.new(attributes) }

    it 'creates an Inbox with all attributes' do
      expect(inbox).to have_attributes(
        id: 123,
        name: 'Example Inbox',
        username: 'example-username',
        password: 'example-password',
        max_size: 123,
        status: 'active',
        email_username: 'example-email-username',
        email_username_enabled: true,
        sent_messages_count: 123,
        forwarded_messages_count: 123,
        used: 123,
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
end
