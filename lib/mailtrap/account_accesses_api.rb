# frozen_string_literal: true

require_relative 'base_api'
require_relative 'account_access'

module Mailtrap
  class AccountAccessesAPI
    include BaseAPI

    attr_reader :account_id

    self.response_class = AccountAccess

    # Retrieves a list of account accesses with optional filtering by domain, inbox, or project IDs
    # @param domain_ids [Array<Integer>] Optional array of domain IDs to filter by
    # @param inbox_ids [Array<Integer>] Optional array of inbox IDs to filter by
    # @param project_ids [Array<Integer>] Optional array of project IDs to filter by
    # @return [AccountAccess] Sandbox message object
    # @!macro api_errors
    def list(domain_ids: [], inbox_ids: [], project_ids: [])
      query_params = {}
      query_params[:domain_ids] = domain_ids unless domain_ids.empty?
      query_params[:inbox_ids] = inbox_ids unless inbox_ids.empty?
      query_params[:project_ids] = project_ids unless project_ids.empty?

      base_list(query_params)
    end

    # Deletes a sandbox message
    # @param account_access_id [Integer] The account access ID
    # @return [AccountAccess] Deleted AccountAccess object
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
