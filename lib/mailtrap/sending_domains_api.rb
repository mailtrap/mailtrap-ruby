# frozen_string_literal: true

require_relative 'base_api'
require_relative 'sending_domain'

module Mailtrap
  class SendingDomainsAPI
    include BaseAPI

    self.supported_options = %i[open_tracking_enabled click_tracking_enabled auto_unsubscribe_link_enabled]

    self.response_class = SendingDomain

    # Lists all sending domains for the account
    # @return [Array<SendingDomain>] Array of sending domains
    # @!macro api_errors
    def list
      response = client.get(base_path)
      response[:data].map { |item| handle_response(item) }
    end

    # Retrieves a specific sending domain
    # @param domain_id [Integer] The sending domain ID
    # @return [SendingDomain] Sending domain object
    # @!macro api_errors
    def get(domain_id)
      base_get(domain_id)
    end

    # Creates a new sending domain
    # @param [Hash] options The parameters to create
    # @option options [String] :domain_name The sending domain name
    # @return [SendingDomain] Created sending domain
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(options)
      base_create(options, %i[domain_name])
    end

    # Deletes a sending domain
    # @param domain_id [Integer] The sending domain ID
    # @return nil
    # @!macro api_errors
    def delete(domain_id)
      base_delete(domain_id)
    end

    # Updates configuration settings for a sending domain
    # @param domain_id [Integer] The sending domain ID
    # @param [Hash] options The parameters to update
    # @option options [Boolean] :open_tracking_enabled Enable open tracking for emails sent from this domain
    # @option options [Boolean] :click_tracking_enabled Enable click tracking for links in emails sent from this domain
    # @option options [Boolean] :auto_unsubscribe_link_enabled Automatically add an unsubscribe link to emails
    # @return [SendingDomain] Updated sending domain
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def update(domain_id, options)
      base_update(domain_id, options)
    end

    # Email DNS configuration instructions for the sending domain
    # @param domain_id [Integer] The sending domain ID
    # @param email [String] The email for instructions
    # @return nil
    # @!macro api_errors
    def send_setup_instructions(domain_id, email:)
      client.post("#{base_path}/#{domain_id}/send_setup_instructions", email:)
    end

    private

    def base_path
      "/api/accounts/#{account_id}/sending_domains"
    end

    def wrap_request(options)
      { sending_domain: options }
    end
  end
end
