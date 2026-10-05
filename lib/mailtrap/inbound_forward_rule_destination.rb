# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for an inbound forward rule destination
  # @see https://docs.mailtrap.io/developers/inbound
  # @attr_reader email [String] The destination email address
  InboundForwardRuleDestination = Struct.new(
    :email,
    keyword_init: true
  )
end
