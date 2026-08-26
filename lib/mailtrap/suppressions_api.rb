# frozen_string_literal: true

require_relative 'base_api'
require_relative 'suppression'

module Mailtrap
  class SuppressionsAPI
    include BaseAPI

    self.supported_options = %i[email domain_id sending_stream type].freeze

    self.response_class = Suppression

    # Lists all suppressions for the account
    # @param email [String] Email address to filter suppressions (optional)
    # @return [Array<Suppression>] Array of suppression objects
    # @!macro api_errors
    def list(email: nil)
      query_params = {}
      query_params[:email] = email if email

      base_list(query_params)
    end

    # Adds an email address to the account's suppression list
    # @param [Hash] options The suppression attributes
    # @option options [String] :email Email address to suppress
    # @option options [Integer] :domain_id ID of the domain to suppress this email for
    # @option options [String] :sending_stream The sending stream to suppress for: "transactional" or "bulk"
    # @option options [String] :type Reason for the suppression, defaults to "manual import" when omitted
    # @return [Suppression] Created suppression
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(options)
      validate_options!(options, supported_options)
      response = client.post(base_path, options)
      build_entity(response[:data], Suppression)
    end

    # Deletes a suppression
    # @param suppression_id [String] The suppression UUID
    # @return [Suppression] The deleted suppression
    # @!macro api_errors
    def delete(suppression_id)
      response = client.delete("#{base_path}/#{suppression_id}")
      build_entity(response, Suppression)
    end

    private

    def base_path
      "/api/accounts/#{account_id}/suppressions"
    end
  end
end
