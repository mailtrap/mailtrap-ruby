# frozen_string_literal: true

require_relative 'base_api'
require_relative 'inbox'

module Mailtrap
  class InboxesAPI
    include BaseAPI

    self.supported_options = %i[name email_username]
    self.response_class = Inbox

    # Lists all Inboxes for the account
    # @return [Array<Inbox>] Array of Inboxes
    # @!macro api_errors
    def list
      base_list
    end

    # Retrieves a specific inbox
    # @param inbox_id [Integer] The inbox identifier
    # @return [Inbox] Inbox object
    # @!macro api_errors
    def get(inbox_id)
      base_get(inbox_id)
    end

    # Creates a new inbox
    # @param [Hash] options The parameters to create
    # @option options [String] :name The inbox name
    # @return [Inbox] Created inbox object
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(options)
      validate_options!(options, supported_options + [:project_id])
      response = client.post("/api/accounts/#{account_id}/projects/#{options[:project_id]}/inboxes",
                             wrap_request(options))
      handle_response(response)
    end

    # Deletes an inbox
    # @param inbox_id [Integer] The Inbox identifier
    # @return nil
    # @!macro api_errors
    def delete(inbox_id)
      base_delete(inbox_id)
    end

    # Updates an existing Inbox
    # @param inbox_id [Integer] The Inbox identifier
    # @param [Hash] options The parameters to update
    # @option options [String] :name The inbox name
    # @option options [String] :email_username The inbox email username
    # @return [Inbox] Updated Inbox object
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def update(inbox_id, options)
      base_update(inbox_id, options)
    end

    # Delete all messages (emails) from Inbox
    # @param inbox_id [Integer] The Inbox identifier
    # @return [Inbox] Updated Inbox object
    # @!macro api_errors
    def clean(inbox_id)
      response = client.patch("#{base_path}/#{inbox_id}/clean")
      handle_response(response)
    end

    # Mark all messages in the inbox as read
    # @param inbox_id [Integer] The Inbox identifier
    # @return [Inbox] Updated Inbox object
    # @!macro api_errors
    def mark_as_read(inbox_id)
      response = client.patch("#{base_path}/#{inbox_id}/all_read")
      handle_response(response)
    end

    # Reset SMTP credentials of the inbox
    # @param inbox_id [Integer] The Inbox identifier
    # @return [Inbox] Updated Inbox object
    # @!macro api_errors
    def reset_credentials(inbox_id)
      response = client.patch("#{base_path}/#{inbox_id}/reset_credentials")
      handle_response(response)
    end

    private

    def wrap_request(options)
      { inbox: options }
    end

    def base_path
      "/api/accounts/#{account_id}/inboxes"
    end
  end
end
