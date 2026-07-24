# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for an inbound thread (summary in list, with embedded messages when fetched by ID)
  # @see https://docs.mailtrap.io/developers/inbound
  # @attr_reader id [String] The thread ID
  # @attr_reader subject [String, nil] The thread subject
  # @attr_reader message_count [Integer] Number of messages in the thread
  # @attr_reader size [Integer] Total size of the thread in bytes
  # @attr_reader first_message_at [String] ISO 8601 timestamp of the first message
  # @attr_reader last_received_at [String, nil] ISO 8601 timestamp of the last received message
  # @attr_reader last_sent_at [String, nil] ISO 8601 timestamp of the last sent message
  # @attr_reader last_activity_at [String] ISO 8601 timestamp of the last activity
  # @attr_reader last_message_id [String, nil] ID of the most recent message
  # @attr_reader senders [Array<String>] Distinct sender addresses in the thread
  # @attr_reader recipients [Array<String>] Distinct recipient addresses in the thread
  # @attr_reader attachments [Array<InboundAttachment>] Attachments across the thread
  # @attr_reader messages [Array<InboundThreadMessage>, nil] The thread's messages (only when fetched by ID)
  # rubocop:disable Lint/StructNewOverride -- +size+ is an API field that shadows Struct#size
  InboundThread = Struct.new(
    :id,
    :subject,
    :message_count,
    :size,
    :first_message_at,
    :last_received_at,
    :last_sent_at,
    :last_activity_at,
    :last_message_id,
    :senders,
    :recipients,
    :attachments,
    :messages,
    keyword_init: true
  )
  # rubocop:enable Lint/StructNewOverride
end
