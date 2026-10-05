# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for an inbound forward rule condition
  # @see https://docs.mailtrap.io/developers/inbound
  # @attr_reader match_type [String] The match type
  # @attr_reader operator [String] The comparison operator
  # @attr_reader value [String, nil] The value to compare against
  # @attr_reader header_key [String, nil] The header name
  InboundForwardRuleCondition = Struct.new(
    :match_type,
    :operator,
    :value,
    :header_key,
    keyword_init: true
  )
end
