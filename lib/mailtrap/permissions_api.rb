# frozen_string_literal: true

require_relative 'base_api'

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

    private

    def base_path
      "/api/accounts/#{account_id}"
    end
  end
end
