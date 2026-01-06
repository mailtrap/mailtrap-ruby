# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Account Access
  # @see https://docs.mailtrap.io/developers/account-management/general-api/access-control
  # @attr_reader id [Integer] The Account Access ID
  # @attr_reader specifier_type [String] The specifier type
  # @attr_reader specifier [Hash] The specifier object
  # @attr_reader resources [Array<Hash>] Array of resources
  # @attr_reader permissions [Hash] Permissions
  #
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
