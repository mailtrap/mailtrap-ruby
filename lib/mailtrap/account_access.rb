# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for AccountAccess
  # @see https://docs.mailtrap.io/developers/account-management/access-control
  # @attr_reader id [Integer] The access ID
  # @attr_reader specifier_type [String] The type of the specifier
  # @attr_reader specifier [Hash] The specifier for the access
  # @attr_reader resources [Array<Hash>] The resources this access applies to
  # @attr_reader permissions [Hash] The permissions granted
  #
  AccountAccess = Struct.new(
    :id,
    :specifier_type,
    :specifier,
    :resources,
    :permissions,
    keyword_init: true
  )
end
