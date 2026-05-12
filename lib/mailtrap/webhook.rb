# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Webhook
  # @see https://api-docs.mailtrap.io/docs/mailtrap-api-docs/8d553c46c2d33-webhooks
  # @attr_reader id [Integer] The webhook ID
  # @attr_reader url [String] The URL that will receive webhook payloads
  # @attr_reader active [Boolean] Whether the webhook is active
  # @attr_reader webhook_type [String] The type of webhook (`email_sending` or `audit_log`)
  # @attr_reader payload_format [String] The webhook payload format (`json` or `jsonlines`)
  # @attr_reader sending_stream [String, nil] The sending stream (`transactional` or `bulk`).
  #   Applicable only for `email_sending` webhooks.
  # @attr_reader domain_id [Integer, nil] The sending domain ID the webhook is scoped to,
  #   or nil for all domains. Applicable only for `email_sending` webhooks.
  # @attr_reader event_types [Array<String>] The event types the webhook is subscribed to.
  #   Applicable only for `email_sending` webhooks.
  # @attr_reader signing_secret [String, nil] HMAC SHA-256 signing secret. Returned only on creation.
  Webhook = Struct.new(
    :id,
    :url,
    :active,
    :webhook_type,
    :payload_format,
    :sending_stream,
    :domain_id,
    :event_types,
    :signing_secret,
    keyword_init: true
  )
end
