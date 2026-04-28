# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for API Token
  # @attr_reader id [Integer] The API token ID
  # @attr_reader name [String] Token display name
  # @attr_reader last_4_digits [String] Last 4 characters of the token
  # @attr_reader created_by [String] Name of the user or token that created this token
  # @attr_reader expires_at [String, nil] When the token expires (ISO 8601); nil if it does not expire
  # @attr_reader resources [Array<Hash>] Permissions granted to this token
  # @attr_reader token [String, nil] Full token value — only populated by #create and #reset
  ApiToken = Struct.new(
    :id,
    :name,
    :last_4_digits,
    :created_by,
    :expires_at,
    :resources,
    :token,
    keyword_init: true
  )
end
