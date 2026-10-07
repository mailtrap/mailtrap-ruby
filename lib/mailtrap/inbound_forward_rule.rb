# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for an inbound forward rule
  # @see https://docs.mailtrap.io/developers/inbound
  # @attr_reader id [Integer] The forward rule ID
  # @attr_reader name [String] The rule name
  # @attr_reader created_at [String] Creation timestamp
  # @attr_reader updated_at [String] Last update timestamp
  # @attr_reader conditions [Array<InboundForwardRuleCondition>] The rule conditions
  # @attr_reader destinations [Array<InboundForwardRuleDestination>] The rule destinations
  InboundForwardRule = Struct.new(
    :id,
    :name,
    :created_at,
    :updated_at,
    :conditions,
    :destinations,
    keyword_init: true
  )
end
