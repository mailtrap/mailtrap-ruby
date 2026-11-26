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
    # @param include_topic_unsubscriptions [Boolean] Whether to include the contacts' subscription topic
    #   unsubscriptions, of type +topic unsubscription+ (optional, default false)
    # @return [Array<Suppression>] Array of suppression objects
    # @!macro api_errors
    def list(email: nil, include_topic_unsubscriptions: false)
      query_params = {}
      query_params[:email] = email if email
      query_params[:include_topic_unsubscriptions] = true if include_topic_unsubscriptions

      base_list(query_params)
    end

    # Adds an email address to the account's suppression list
    # @param [Hash] options The suppression attributes
    # @option options [String] :email Email address to suppress
    # @option options [Integer] :domain_id ID of the domain to suppress this email for
    # @option options [String] :sending_stream The sending stream to suppress for: "transactional" or "bulk"
    # @option options [String] :type Reason for the suppression, defaults to "manual import" when omitted.
    #   A +topic unsubscription+ is only listed, not created
    # @return [Suppression] Created suppression
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(options)
      validate_options!(options, supported_options)
      response = client.post(base_path, options)
      build_entity(response[:data], Suppression)
    end

    # Deletes a suppression. A +topic unsubscription+ cannot be deleted: resubscribe the contact
    # with +subscription_topics+ in {ContactsAPI#upsert} instead
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
