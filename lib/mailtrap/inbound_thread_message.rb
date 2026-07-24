# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for a message inside an inbound thread.
  # Only +visibility_status+ and +direction+ are always present; +placeholder+ entries omit the rest,
  # and the delivery lifecycle fields are only set on available outbound messages.
  # @see https://docs.mailtrap.io/developers/inbound
  # @attr_reader visibility_status [String] available or placeholder
  # @attr_reader direction [String] inbound or outbound
  # @attr_reader id [String, nil] The message ID
  # @attr_reader message_group_id [String, nil] Groups messages sent together as one logical send
  # @attr_reader subject [String, nil] Email subject
  # @attr_reader rfc_message_id [String, nil] Value of the RFC 5322 Message-ID header
  # @attr_reader in_reply_to [String, nil] Value of the RFC 5322 In-Reply-To header
  # @attr_reader references [Array<String>, nil] Values of the RFC 5322 References header
  # @attr_reader from [String, nil] Sender address
  # @attr_reader to [Array<String>, nil] Recipient addresses
  # @attr_reader cc [Array<String>, nil] Cc addresses
  # @attr_reader bcc [Array<String>, nil] Bcc addresses
  # @attr_reader reply_to [String, nil] Reply-To address
  # @attr_reader created_at [String, nil] ISO 8601 timestamp
  # @attr_reader email_size [Integer, nil] Message size in bytes
  # @attr_reader text_body [String, nil] Decoded text body
  # @attr_reader html_body [String, nil] Decoded HTML body
  # @attr_reader attachments [Array<InboundAttachment>, nil] The message attachments
  # @attr_reader delivery_status [String, nil] Delivery status (outbound messages only)
  # @attr_reader delivered_at [String, nil] Delivery timestamp (outbound messages only)
  # @attr_reader bounced_at [String, nil] Bounce timestamp (outbound messages only)
  InboundThreadMessage = Struct.new(
    :visibility_status,
    :direction,
    :id,
    :message_group_id,
    :subject,
    :rfc_message_id,
    :in_reply_to,
    :references,
    :from,
    :to,
    :cc,
    :bcc,
    :reply_to,
    :created_at,
    :email_size,
    :text_body,
    :html_body,
    :attachments,
    :delivery_status,
    :delivered_at,
    :bounced_at,
    keyword_init: true
  )
end
