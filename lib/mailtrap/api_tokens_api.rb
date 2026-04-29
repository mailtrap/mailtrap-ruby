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

    # Retrieves a single API token by ID
    # @param token_id [Integer] The API token ID
    # @return [ApiToken] API token object (the `token` field is nil — full value is only
    #   returned by #create and #reset)
    # @!macro api_errors
    def get(token_id)
      base_get(token_id)
    end

    private

    def base_path
      "/api/accounts/#{account_id}/api_tokens"
    end
  end
end
