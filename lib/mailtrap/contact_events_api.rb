# frozen_string_literal: true

require_relative 'base_api'
require_relative 'contact_event'

module Mailtrap
  class ContactEventsAPI
    include BaseAPI

    self.supported_options = %i[name params].freeze

    self.response_class = ContactEvent

    # Creates a contact event
    # @param contact_identifier [String] The contact UUID or email address
    # @param [Hash] options The event parameters
    # @option options [String] :name The event name (max 255 characters)
    # @option options [Hash] :params A hash of string keys and scalar values
    # @return [ContactEvent] Created contact event object
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(contact_identifier, options)
      validate_options!(options, supported_options)
      response = client.post(base_path(contact_identifier), options)
      build_entity(response, ContactEvent)
    end

    private

    def base_path(contact_identifier)
      "/api/accounts/#{account_id}/contacts/#{contact_identifier}/events"
    end
  end
end
