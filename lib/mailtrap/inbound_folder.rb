# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for an inbound folder
  # @see https://docs.mailtrap.io/developers/inbound
  # @attr_reader id [Integer] The folder ID
  # @attr_reader name [String] The folder name
  InboundFolder = Struct.new(
    :id,
    :name,
    keyword_init: true
  )
end
