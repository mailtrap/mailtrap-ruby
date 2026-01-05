# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Sandbox Message
  # @see https://docs.mailtrap.io/developers/email-sandbox/email-sandbox-api/messages
  # @attr_reader id [Integer] The message ID
  # @attr_reader inbox_id [Integer] The inbox ID
  # @attr_reader subject [String] The message subject
  # @attr_reader sent_at [String] The timestamp when the message was sent
  # @attr_reader from_email [String] The sender's email address
  # @attr_reader from_name [String] The sender's name
  # @attr_reader to_email [String] The recipient's email address
  # @attr_reader to_name [String] The recipient's name
  # @attr_reader email_size [Integer] The size of the email in bytes
  # @attr_reader is_read [Boolean] Whether the message has been read
  # @attr_reader created_at [String] The timestamp when the message was created
  # @attr_reader updated_at [String] The timestamp when the message was last updated
  # @attr_reader html_body_size [Integer] The size of the HTML body in bytes
  # @attr_reader text_body_size [Integer] The size of the text body in bytes
  # @attr_reader human_size [String] The human-readable size of the email
  # @attr_reader html_path [String] The path to the HTML version of the email
  # @attr_reader txt_path [String] The path to the text version of the email
  # @attr_reader raw_path [String] The path to the raw version of the email
  # @attr_reader download_path [String] The path to download the email
  # @attr_reader html_source_path [String] The path to the HTML source of the email
  # @attr_reader blacklists_report_info [Boolean] Information about blacklists report
  # @attr_reader smtp_information [Hash] Information about SMTP
  #
  SandboxMessage = Struct.new(
    :id,
    :inbox_id,
    :subject,
    :sent_at,
    :from_email,
    :from_name,
    :to_email,
    :to_name,
    :email_size,
    :is_read,
    :created_at,
    :updated_at,
    :html_body_size,
    :text_body_size,
    :human_size,
    :html_path,
    :txt_path,
    :raw_path,
    :download_path,
    :html_source_path,
    :blacklists_report_info,
    :smtp_information,
    keyword_init: true
  ) do
    # @return [Hash] The SendingDomain attributes as a hash
    def to_h
      super.compact
    end
  end
end
