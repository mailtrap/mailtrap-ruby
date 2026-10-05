# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for the delivery of an outbound message inside an inbound thread
  # @see https://docs.mailtrap.io/developers/inbound
  # @attr_reader to [String] The recipient address
  # @attr_reader status [String] The delivery status
  # @attr_reader delivered_at [String, nil] Delivery timestamp
  # @attr_reader bounced_at [String, nil] Bounce timestamp
  InboundThreadMessageDelivery = Struct.new(
    :to,
    :status,
    :delivered_at,
    :bounced_at,
    keyword_init: true
  )
end
