# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for an email log message (summary in list, full details when fetched by ID)
  # @see https://docs.mailtrap.io/developers/email-sending/email-logs
  # @attr_reader message_id [String] Message UUID
  # @attr_reader status [String] delivered, not_delivered, enqueued, opted_out
  # @attr_reader subject [String, nil] Email subject
  # @attr_reader from [String] Sender address
  # @attr_reader to [String] Recipient address
  # @attr_reader sent_at [String] ISO 8601 timestamp
  # @attr_reader client_ip [String, nil] Client IP that sent the email
  # @attr_reader category [String, nil] Message category
  # @attr_reader custom_variables [Hash] Custom variables
  # @attr_reader sending_stream [String] transactional or bulk
  # @attr_reader sending_domain_id [Integer] Sending domain ID
  # @attr_reader template_id [Integer, nil] Template ID if sent from template
  # @attr_reader template_variables [Hash] Template variables
  # @attr_reader opens_count [Integer] Number of opens
  # @attr_reader clicks_count [Integer] Number of clicks
  # @attr_reader raw_message_url [String, nil] Signed URL to download raw .eml (only when fetched by ID)
  # @attr_reader events [Array<EmailLogEvent>, nil] Event list (only when fetched by ID)
  EmailLogMessage = Struct.new(
    :message_id,
    :status,
    :subject,
    :from,
    :to,
    :sent_at,
    :client_ip,
    :category,
    :custom_variables,
    :sending_stream,
    :sending_domain_id,
    :template_id,
    :template_variables,
    :opens_count,
    :clicks_count,
    :raw_message_url,
    :events,
    keyword_init: true
  )
end
