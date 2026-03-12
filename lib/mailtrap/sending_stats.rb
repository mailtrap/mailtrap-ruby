# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Sending Stats data
  # @see https://docs.mailtrap.io/developers/email-sending-stats
  # @attr_reader delivery_count [Integer] Number of delivered emails
  # @attr_reader delivery_rate [Float] Delivery rate
  # @attr_reader bounce_count [Integer] Number of bounced emails
  # @attr_reader bounce_rate [Float] Bounce rate
  # @attr_reader open_count [Integer] Number of opened emails
  # @attr_reader open_rate [Float] Open rate
  # @attr_reader click_count [Integer] Number of clicked emails
  # @attr_reader click_rate [Float] Click rate
  # @attr_reader spam_count [Integer] Number of spam reports
  # @attr_reader spam_rate [Float] Spam rate
  #
  SendingStats = Struct.new(
    :delivery_count,
    :delivery_rate,
    :bounce_count,
    :bounce_rate,
    :open_count,
    :open_rate,
    :click_count,
    :click_rate,
    :spam_count,
    :spam_rate,
    keyword_init: true
  )
end
