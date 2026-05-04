# frozen_string_literal: true

require_relative 'base_api'
require_relative 'contact_export'

module Mailtrap
  class ContactExportsAPI
    include BaseAPI

    self.supported_options = %i[filters].freeze

    self.response_class = ContactExport

    # Retrieves a specific contact export
    # @param export_id [Integer] The contact export ID
    # @return [ContactExport] Contact export object
    # @!macro api_errors
    def get(export_id)
      base_get(export_id)
    end

    # Creates a new contact export
    # @param [Hash] options The export parameters
    # @option options [Array<Hash>] :filters Filters to apply to the export
    #   - `{ name: 'list_id', operator: 'equal', value: [Integer, ...] }`
    #   - `{ name: 'subscription_status', operator: 'equal', value: 'subscribed' | 'unsubscribed' }`
    # @return [ContactExport] Created contact export object
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(options)
      base_create(options)
    end

    private

    def base_path
      "/api/accounts/#{account_id}/contacts/exports"
    end
  end
end
