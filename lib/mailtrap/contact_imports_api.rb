# frozen_string_literal: true

require_relative 'contact_import'
require_relative 'contacts_import_request'

module Mailtrap
  class ContactImportsAPI
    include BaseAPI

    self.supported_options = %i[email fields list_ids_included list_ids_excluded]

    self.response_class = ContactImport

    # Retrieves a specific contact import
    # @param import_id [Integer] The contact import identifier
    # @return [ContactImport] Contact import object
    # @!macro api_errors
    def get(import_id)
      base_get(import_id)
    end

    # Create contacts import
    #
    # @example Using Mailtrap::ContactsImportRequest
    #   import_request = Mailtrap::ContactsImportRequest.new.tap do |req|
    #     req.upsert(email: 'jane@example.com', fields: { first_name: 'Jane' })
    #       .add_to_lists(email: 'jane@example.com', list_ids: [1])
    #       .remove_from_lists(email: 'jane@example.com', list_ids: [2])
    #     req.upsert(email: 'john@example.com', fields: { first_name: 'John' })
    #       .add_to_lists(email: 'john@example.com', list_ids: [1])
    #       .remove_from_lists(email: 'john@example.com', list_ids: [2])
    #   end
    #   contact_imports.create(import_request)
    #
    # @example Using plain hash
    #   contact_imports.create([
    #     {email: 'john@example.com', fields: { first_name: 'John' }, list_ids_included: [1], list_ids_excluded: [2]},
    #     {email: 'jane@example.com', fields: { first_name: 'Jane' }, list_ids_included: [1], list_ids_excluded: [2]}
    #   ])
    #
    # @param contacts [Mailtrap::ContactsImportRequest, Array<Hash>] The contacts import request
    #
    # @return [ContactImport] Created contact list object
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(contacts)
      contact_data = contacts.to_a.each do |contact|
        validate_options!(contact, supported_options)
      end
      response = client.post(base_path, contacts: contact_data)
      handle_response(response)
    end
    alias start create

    private

    def base_path
      "/api/accounts/#{account_id}/contacts/imports"
    end
  end
end
