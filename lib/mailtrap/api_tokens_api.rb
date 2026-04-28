# frozen_string_literal: true

require_relative 'base_api'
require_relative 'api_token'

module Mailtrap
  class ApiTokensAPI
    include BaseAPI

    self.response_class = ApiToken

    # Lists API tokens visible to the current API token
    # @return [Array<ApiToken>] Array of API tokens
    # @!macro api_errors
    def list
      base_list
    end

    private

    def base_path
      "/api/accounts/#{account_id}/api_tokens"
    end
  end
end
