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
      validate_email!(email)

      @data[email][:fields].merge!(fields)

      self
    end

    # Adds a contact to the specified lists
    # @param email [String] The contact's email address
    # @param list_ids [Array<Integer>] Array of list IDs to add the contact to
    # @return [ContactsImportRequest] Returns self for method chaining
    def add_to_lists(email:, list_ids:)
      validate_email!(email)

      append_list_ids email:, list_ids:, key: :list_ids_included

      self
    end

    # Removes a contact from the specified lists
    # @param email [String] The contact's email address
    # @param list_ids [Array<Integer>] Array of list IDs to remove the contact from
    # @return [ContactsImportRequest] Returns self for method chaining
    def remove_from_lists(email:, list_ids:)
      validate_email!(email)

      append_list_ids email:, list_ids:, key: :list_ids_excluded

      self
    end

    # Sets the contact's subscription topic preferences; preferences left out keep their status, and
    # a later preference for the same topic and domain replaces the earlier one.
    # Importing them fails on an account without subscription topics.
    # @param email [String] The contact's email address
    # @param subscription_topics [Array<Hash>] Preferences, each +{ subscription_topic_id:, domain_id:, status: }+
    #   with +status+ +subscribed+ or +unsubscribed+ and +domain_id+ the sending domain it applies to
    # @return [ContactsImportRequest] Returns self for method chaining
    def update_subscription_topics(email:, subscription_topics:)
      validate_email!(email)
      raise ArgumentError, 'subscription_topics must be present' if subscription_topics.empty?

      merge_subscription_topics(email:, subscription_topics:)

      self
    end

    # @return [Array<Hash>] Array of contact objects ready for import
    def to_a
      @data.values
    end

    private

    def validate_email!(email)
      raise ArgumentError, 'email must be present' if email.nil? || email.empty?
    end

    def append_list_ids(email:, list_ids:, key:)
      raise ArgumentError, 'list_ids must be present' if list_ids.empty?

      @data[email][key] |= list_ids
    end

    # The API rejects an import that repeats a topic and domain for a contact
    def merge_subscription_topics(email:, subscription_topics:)
      preferences = Array(@data[email][:subscription_topics]).to_h do |preference|
        [preference.values_at(:subscription_topic_id, :domain_id), preference]
      end
      subscription_topics.each do |preference|
        preference = preference.transform_keys(&:to_sym)
        preferences[preference.values_at(:subscription_topic_id, :domain_id)] = preference
      end
      @data[email][:subscription_topics] = preferences.values
    end
  end
end
