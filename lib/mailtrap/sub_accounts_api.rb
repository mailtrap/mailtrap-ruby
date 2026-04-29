# frozen_string_literal: true

require_relative 'base_api'
require_relative 'sub_account'

module Mailtrap
  class SubAccountsAPI
    include BaseAPI

    attr_reader :organization_id

    self.supported_options = %i[name].freeze

    self.response_class = SubAccount

    # @param organization_id [Integer] The organization ID
    # @param client [Mailtrap::Client] The client instance
    # @raise [ArgumentError] If organization_id is nil
    def initialize(organization_id, client = Mailtrap::Client.new)
      raise ArgumentError, 'organization_id is required' if organization_id.nil?

      @organization_id = organization_id
      @client = client
    end

    # Creates a new sub account under the organization
    # @param [Hash] options The parameters to create
    # @option options [String] :name Name of the sub account
    # @return [SubAccount] Created sub account
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(options)
      base_create(options)
    end

    private

    def base_path
      "/api/organizations/#{organization_id}/sub_accounts"
    end

    def wrap_request(options)
      { account: options }
    end
  end
end
