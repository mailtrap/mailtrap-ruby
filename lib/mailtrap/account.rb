# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Project
  # @see https://docs.mailtrap.io/developers/account-management/general-api/accounts
  # @attr_reader id [Integer] The account ID
  # @attr_reader name [String] The account name
  # @attr_reader access_levels [Array] The account access levels
  #
  Account = Struct.new(
    :id,
    :name,
    :access_levels,
    keyword_init: true
  ) do
    # @return [Hash] The Project attributes as a hash
    def to_h
      super.compact
    end
  end
end
