# frozen_string_literal: true

require_relative 'base_api'
require_relative 'inbound_inbox'

module Mailtrap
  class InboundInboxesAPI
    include BaseAPI

    self.response_class = InboundInbox

    CREATE_OPTIONS = %i[name domain_id].freeze
    UPDATE_OPTIONS = %i[name].freeze

    # Inbound is scoped to the token's account, so no account_id is required.
    # @param client [Mailtrap::Client] The client instance
    def initialize(client = Mailtrap::Client.new)
      @client = client
    end

    # Lists all inboxes in a folder
    # @param folder_id [Integer] The folder ID
    # @return [Array<InboundInbox>] Array of inboxes
    # @!macro api_errors
    def list(folder_id)
      client.get(inboxes_path(folder_id)).map { |item| handle_response(item) }
    end

    # Retrieves a specific inbox
    # @param folder_id [Integer] The folder ID
    # @param inbox_id [Integer] The inbox ID
    # @return [InboundInbox] Inbox object
    # @!macro api_errors
    def get(folder_id, inbox_id)
      handle_response(client.get("#{inboxes_path(folder_id)}/#{inbox_id}"))
    end

    # Creates a new inbox in a folder
    # @param folder_id [Integer] The folder ID
    # @param [Hash] options The parameters to create
    # @option options [String] :name The inbox name
    # @option options [Integer] :domain_id Attach to a custom domain; omit for a Mailtrap-hosted inbox
    # @return [InboundInbox] Created inbox
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(folder_id, options)
      validate_options!(options, CREATE_OPTIONS)
      handle_response(client.post(inboxes_path(folder_id), options))
    end

    # Updates an inbox
    # @param folder_id [Integer] The folder ID
    # @param inbox_id [Integer] The inbox ID
    # @param [Hash] options The parameters to update
    # @option options [String] :name The inbox name
    # @return [InboundInbox] Updated inbox
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def update(folder_id, inbox_id, options)
      validate_options!(options, UPDATE_OPTIONS)
      handle_response(client.patch("#{inboxes_path(folder_id)}/#{inbox_id}", options))
    end

    # Deletes an inbox
    # @param folder_id [Integer] The folder ID
    # @param inbox_id [Integer] The inbox ID
    # @return nil
    # @!macro api_errors
    def delete(folder_id, inbox_id)
      client.delete("#{inboxes_path(folder_id)}/#{inbox_id}")
    end

    private

    def inboxes_path(folder_id)
      "/api/inbound/folders/#{folder_id}/inboxes"
    end
  end
end
