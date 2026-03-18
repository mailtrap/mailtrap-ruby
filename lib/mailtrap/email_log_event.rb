# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for an email log event (delivery, open, click, bounce, etc.)
  # @see https://docs.mailtrap.io/developers/email-sending/email-logs
  # @attr_reader event_type [String] One of: delivery, open, click, soft_bounce, bounce, spam, unsubscribe, suspension,
  #   reject
  # @attr_reader created_at [String] ISO 8601 timestamp
  # @attr_reader details [EmailLogEventDetails::Delivery, EmailLogEventDetails::Open, EmailLogEventDetails::Click,
  #   EmailLogEventDetails::Bounce, EmailLogEventDetails::Spam, EmailLogEventDetails::Unsubscribe,
  #   EmailLogEventDetails::Reject] Type-specific event details
  EmailLogEvent = Struct.new(
    :event_type,
    :created_at,
    :details,
    keyword_init: true
  )
end
