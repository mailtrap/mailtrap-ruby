# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Email Marketing Stats
  #
  # Aggregated metrics of the account's Email Marketing traffic (campaigns and automations) for
  # the requested period and filters. Rates are fractions from 0 to 1. Every count and rate is +0+
  # when nothing matched.
  # @see https://docs.mailtrap.io/developers/email-marketing/marketing-stats
  # @attr_reader delivery_count [Integer] Number of delivered messages
  # @attr_reader delivery_rate [Float] Share of sent messages that were delivered (0–1)
  # @attr_reader bounce_count [Integer] Number of bounced messages
  # @attr_reader bounce_rate [Float] Share of sent messages that bounced (0–1)
  # @attr_reader open_count [Integer] Number of opened messages
  # @attr_reader open_rate [Float] Share of delivered messages that were opened (0–1)
  # @attr_reader click_count [Integer] Number of clicked messages
  # @attr_reader click_rate [Float] Share of delivered messages that were clicked (0–1)
  # @attr_reader spam_count [Integer] Number of spam complaints
  # @attr_reader spam_rate [Float] Share of delivered messages marked as spam (0–1)
  # @attr_reader unsubscription_count [Integer] Number of unsubscriptions
  # @attr_reader unsubscription_rate [Float] Share of delivered messages that unsubscribed (0–1)
  # @attr_reader sent_count [Integer] Number of sent messages (delivered plus bounced)
  MarketingStats = Struct.new(
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
    :unsubscription_count,
    :unsubscription_rate,
    :sent_count,
    keyword_init: true
  )
end
