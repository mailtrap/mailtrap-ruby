# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for an inbound forward outcome
  # @see https://docs.mailtrap.io/developers/inbound
  # @attr_reader rule_id [Integer] The forward rule ID
  # @attr_reader rule_name [String, nil] The forward rule name
  # @attr_reader destination [String] The destination address
  # @attr_reader status [String] forwarded or rejected
  # @attr_reader reason [String, nil] The rejection reason
  # @attr_reader message_id [String, nil] The forwarded message ID
  InboundForwardOutcome = Struct.new(
    :rule_id,
    :rule_name,
    :destination,
    :status,
    :reason,
    :message_id,
    keyword_init: true
  )
end
