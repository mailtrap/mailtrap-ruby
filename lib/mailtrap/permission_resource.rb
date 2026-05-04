# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for a node in the Permissions resources tree
  # @attr_reader id [Integer] Resource ID
  # @attr_reader name [String] Resource name
  # @attr_reader type [String] Resource type (account, project, inbox, sending_domain, ...)
  # @attr_reader access_level [Integer] The access level the current token has on this resource
  # @attr_reader resources [Array<PermissionResource>] Nested child resources
  PermissionResource = Struct.new(
    :id,
    :name,
    :type,
    :access_level,
    :resources,
    keyword_init: true
  )
end
