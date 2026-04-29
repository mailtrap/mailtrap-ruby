# frozen_string_literal: true

require_relative 'base_api'
require_relative 'api_token'

module Mailtrap
  class ApiTokensAPI
    include BaseAPI

    self.supported_options = %i[name resources].freeze

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

    # Creates a new API token. The full `token` value is returned ONLY ONCE — store it securely.
    # @param [Hash] options The parameters to create
    # @option options [String] :name Display name for the token
    # @option options [Array<Hash>] :resources Permissions to assign
    #   - `{ resource_type:, resource_id:, access_level: }`
    # @return [ApiToken] Created token (full `token` value populated)
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(options)
      base_create(options)
    end

    # Expires the requested token and returns a new one with the same permissions.
    # The old token stops working after a short grace period. The new `token` value is
    # returned ONLY ONCE — store it securely. Only tokens that have not already been reset
    # can be reset.
    # @param token_id [Integer] The API token ID
    # @return [ApiToken] New token (full `token` value populated)
    # @!macro api_errors
    def reset(token_id)
      response = client.post("#{base_path}/#{token_id}/reset")
      handle_response(response)
    end

    # Permanently deletes an API token
    # @param token_id [Integer] The API token ID
    # @return nil
    # @!macro api_errors
    def delete(token_id)
      base_delete(token_id)
    end

    private

    def base_path
      "/api/accounts/#{account_id}/api_tokens"
    end
  end
end
