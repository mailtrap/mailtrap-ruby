# frozen_string_literal: true

require_relative 'base_api'
require_relative 'account_access'

module Mailtrap
  class AccountAccessesAPI
    include BaseAPI

    self.response_class = AccountAccess

    # Lists all account accesses for the account
    # @return [Array<AccountAccess>] Array of AccountAccesses
    # @!macro api_errors
    def list
      base_list
    end

    # Deletes an account access
    # @param account_access_id [Integer] The account access ID
    # @return nil
    # @!macro api_errors
    def delete(account_access_id)
      base_delete(account_access_id)
    end

    private

    def base_path
      "/api/accounts/#{account_id}/account_accesses"
    end
  end
end
