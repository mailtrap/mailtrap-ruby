# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for an inbound inbox
  # @see https://docs.mailtrap.io/developers/inbound
  # @attr_reader id [Integer] The inbox ID
  # @attr_reader name [String] The inbox name
  # @attr_reader address [String] The inbox's inbound address
  # @attr_reader domain_id [Integer] The sending domain the inbox is attached to
  InboundInbox = Struct.new(
    :id,
    :name,
    :address,
    :domain_id,
    keyword_init: true
  )
end
