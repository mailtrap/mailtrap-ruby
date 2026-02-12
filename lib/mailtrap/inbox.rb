# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Inbox
  # @see https://api-docs.mailtrap.io/docs/mailtrap-api-docs/ee252e413d78a-create-project
  # @attr_reader id [Integer] The inbox ID
  # @attr_reader name [String] The inbox name
  # @attr_reader username [String] The inbox username
  # @attr_reader password [String, nil] The inbox password
  # @attr_reader max_size [Integer] The maximum inbox size in MB
  # @attr_reader status [String] The inbox status
  # @attr_reader email_username [String] The email username
  # @attr_reader email_username_enabled [Boolean] Whether the email username is enabled
  # @attr_reader sent_messages_count [Integer] The count of sent messages
  # @attr_reader forwarded_messages_count [Integer] The count of forwarded messages
  # @attr_reader used [Integer] The used inbox size in MB
  # @attr_reader forward_from_email_address [String] The forwarding email address
  # @attr_reader project_id [Integer] The associated project ID
  # @attr_reader domain [String] The inbox domain
  # @attr_reader pop3_domain [String] The POP3 domain
  # @attr_reader email_domain [String] The email domain
  # @attr_reader api_domain [String] The API domain
  # @attr_reader emails_count [Integer] The total number of emails
  # @attr_reader emails_unread_count [Integer] The number of unread emails
  # @attr_reader last_message_sent_at [String, nil] The timestamp of the last sent message
  # @attr_reader smtp_ports [Array<Integer>] The list of SMTP ports
  # @attr_reader pop3_ports [Array<Integer>] The list of POP3 ports
  # @attr_reader max_message_size [Integer] The maximum message size in MB
  # @attr_reader permissions [Hash] List of permissions
  Inbox = Struct.new(
    :id,
    :name,
    :username,
    :password,
    :max_size,
    :status,
    :email_username,
    :email_username_enabled,
    :sent_messages_count,
    :forwarded_messages_count,
    :used,
    :forward_from_email_address,
    :project_id,
    :domain,
    :pop3_domain,
    :email_domain,
    :api_domain,
    :emails_count,
    :emails_unread_count,
    :last_message_sent_at,
    :smtp_ports,
    :pop3_ports,
    :max_message_size,
    :permissions,
    keyword_init: true
  )
end
