# frozen_string_literal: true

require_relative 'base_api'
require_relative 'company_info'

module Mailtrap
  class CompanyInfoAPI
    include BaseAPI

    self.supported_options = %i[
      name
      address
      city
      country
      phone
      zip_code
      privacy_policy_url
      terms_of_service_url
      website_url
      info_level
    ].freeze

    self.response_class = CompanyInfo

    # Creates company information for a sending domain
    # @param sending_domain_id [Integer] The sending domain ID
    # @param [Hash] options The company info attributes
    # @option options [String] :name Company or individual name
    # @option options [String] :address Street address
    # @option options [String] :city City
    # @option options [String] :country Country
    # @option options [String] :phone Phone number
    # @option options [String] :zip_code ZIP or postal code
    # @option options [String] :privacy_policy_url URL to the privacy policy page
    # @option options [String] :terms_of_service_url URL to the terms of service page
    # @option options [String] :website_url Company website URL
    # @option options [String] :info_level Whether the sender is a "business" or "individual"
    # @return [CompanyInfo] Created company information
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(sending_domain_id, options)
      validate_options!(options, supported_options)
      response = client.post(base_path(sending_domain_id), wrap_request(options))
      build_entity(response[:data], CompanyInfo)
    end

    private

    def base_path(sending_domain_id)
      "/api/accounts/#{account_id}/sending_domains/#{sending_domain_id}/company_info"
    end

    def wrap_request(options)
      { company_info: options }
    end
  end
end
