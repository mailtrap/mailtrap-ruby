# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for an organization sub account
  # @attr_reader id [Integer] The sub account ID
  # @attr_reader name [String] The sub account name
  SubAccount = Struct.new(
    :id,
    :name,
    keyword_init: true
  )
end
