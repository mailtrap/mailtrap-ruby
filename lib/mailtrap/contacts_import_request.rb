# frozen_string_literal: true

module Mailtrap
  # A builder class for creating contact import requests
  # Allows you to build a collection of contacts with their associated fields and list memberships
  class ContactsImportRequest
    def initialize
      @data = Hash.new do |h, k|
        h[k] = { email: k, fields: {}, list_ids_included: [], list_ids_excluded: [] }
      end
    end

    # Creates or updates a contact with the provided email and fields
    # @param email [String] The contact's email address
    # @param fields [Hash] Contact fields in the format: field_merge_tag => String, Integer, Float, Boolean, or
    #   ISO-8601 date string (yyyy-mm-dd)
    # @return [ContactsImportRequest] Returns self for method chaining
    def upsert(email:, fields: {})
      @data[email][:fields].merge!(fields)

      self
    end

    # Adds a contact to the specified lists
    # @param email [String] The contact's email address
    # @param list_ids [Array<Integer>] Array of list IDs to add the contact to
    # @return [ContactsImportRequest] Returns self for method chaining
    def add_to_lists(email:, list_ids:)
      append_list_ids email:, list_ids:, key: :list_ids_included

      self
    end

    # Removes a contact from the specified lists
    # @param email [String] The contact's email address
    # @param list_ids [Array<Integer>] Array of list IDs to remove the contact from
    # @return [ContactsImportRequest] Returns self for method chaining
    def remove_from_lists(email:, list_ids:)
      append_list_ids email:, list_ids:, key: :list_ids_excluded

      self
    end

    # Converts the import request to a JSON-serializable array
    # @return [Array<Hash>] Array of contact objects ready for import
    def as_json
      @data.values
    end
    alias to_a as_json

    private

    def append_list_ids(email:, list_ids:, key:)
      raise ArgumentError, 'list_ids must not be empty' if list_ids.empty?

      @data[email][key] |= list_ids
    end
  end
end
