# frozen_string_literal: true

require_relative 'base_api'
require_relative 'permission_resource'

module Mailtrap
  class PermissionsAPI
    include BaseAPI

    # Bulk-updates user or token permissions on an account access
    # @param account_access_id [Integer] The account access ID
    # @param permissions [Array<Hash>] Array of permission entries
    #   - `{ resource_id:, resource_type:, access_level: }` to create or update
    #   - `{ resource_id:, resource_type:, _destroy: true }` to remove
    # @return [Hash] API response (e.g. `{ message: 'Permissions have been updated!' }`)
    # @!macro api_errors
    def bulk_update(account_access_id, permissions)
      client.put(
        "#{base_path}/account_accesses/#{account_access_id}/permissions/bulk",
        { permissions: permissions }
      )
    end

    # Returns the recursive tree of resources the current token can access.
    # Each node carries the token's access_level and any nested child resources.
    # @return [Array<PermissionResource>] Top-level resources, each with nested children
    # @!macro api_errors
    def resources
      response = client.get("#{base_path}/permissions/resources")
      build_resource_tree(response)
    end

    private

    def base_path
      "/api/accounts/#{account_id}"
    end

    def build_resource_tree(items)
      items.map do |item|
        PermissionResource.new(
          id: item[:id],
          name: item[:name],
          type: item[:type],
          access_level: item[:access_level],
          resources: build_resource_tree(Array(item[:resources]))
        )
      end
    end
  end
end
