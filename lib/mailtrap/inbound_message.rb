# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for an inbound message (summary in list, full details when fetched by ID)
  # @see https://docs.mailtrap.io/developers/inbound
  # @attr_reader id [String] The Mailtrap object ID (not the RFC Message-ID header)
  # @attr_reader inbox_id [Integer] The inbox the message was received in
  # @attr_reader from [String, nil] Sender address
  # @attr_reader to [Array<String>] Recipient addresses
  # @attr_reader cc [Array<String>] Cc addresses
  # @attr_reader bcc [Array<String>] Bcc addresses
  # @attr_reader reply_to [String, nil] Reply-To address
  # @attr_reader subject [String, nil] Email subject
  # @attr_reader rfc_message_id [String, nil] Value of the RFC 5322 Message-ID header
  # @attr_reader in_reply_to [String, nil] Value of the RFC 5322 In-Reply-To header
  # @attr_reader references [Array<String>] Values of the RFC 5322 References header
  # @attr_reader headers [Hash, nil] Raw message headers
  # @attr_reader size [Integer, nil] Total message size in bytes
  # @attr_reader html_size [Integer, nil] HTML body size in bytes
  # @attr_reader text_size [Integer, nil] Text body size in bytes
  # @attr_reader received_at [String] ISO 8601 timestamp when the message was received
  # @attr_reader thread_id [String, nil] ID of the thread this message belongs to, if any
  # @attr_reader attachments [Array<InboundAttachment>] The message attachments
  # @attr_reader raw_message_url [String, nil] Signed URL to download raw .eml (only when fetched by ID)
  # @attr_reader raw_message_expires_at [String, nil] When the raw message URL expires (only when fetched by ID)
  # @attr_reader html_body [String, nil] Decoded HTML body (only when fetched by ID)
  # @attr_reader text_body [String, nil] Decoded text body (only when fetched by ID)
  # rubocop:disable Lint/StructNewOverride -- +size+ is an API field that shadows Struct#size
  InboundMessage = Struct.new(
    :id,
    :inbox_id,
    :from,
    :to,
    :cc,
    :bcc,
    :reply_to,
    :subject,
    :rfc_message_id,
    :in_reply_to,
    :references,
    :headers,
    :size,
    :html_size,
    :text_size,
    :received_at,
    :thread_id,
    :attachments,
    :raw_message_url,
    :raw_message_expires_at,
    :html_body,
    :text_body,
    keyword_init: true
  )
  # rubocop:enable Lint/StructNewOverride
end
