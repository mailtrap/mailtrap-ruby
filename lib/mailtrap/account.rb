# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Фссщгте
  # @see https://api-docs.mailtrap.io/docs/mailtrap-api-docs/d26921ca2a48f-get-all-accounts
  # @attr_reader id [Integer] The account ID
  # @attr_reader name [String] The account name
  # @attr_reader access_levels [Array] The account access levels
  #
  Account = Struct.new(
    :id,
    :name,
    :access_levels,
    keyword_init: true
  )
end
