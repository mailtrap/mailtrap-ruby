# frozen_string_literal: true

require_relative 'base_api'
require_relative 'inbound_folder'

module Mailtrap
  class InboundFoldersAPI
    include BaseAPI

    self.supported_options = %i[name]
    self.response_class = InboundFolder

    # Inbound is scoped to the token's account, so no account_id is required.
    # @param client [Mailtrap::Client] The client instance
    def initialize(client = Mailtrap::Client.new)
      @client = client
    end

    # Lists all inbound folders in the account
    # @return [Array<InboundFolder>] Array of folders
    # @!macro api_errors
    def list
      base_list
    end

    # Retrieves a specific inbound folder
    # @param folder_id [Integer] The folder ID
    # @return [InboundFolder] Folder object
    # @!macro api_errors
    def get(folder_id)
      base_get(folder_id)
    end

    # Creates a new inbound folder
    # @param [Hash] options The parameters to create
    # @option options [String] :name The folder name
    # @return [InboundFolder] Created folder
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(options)
      base_create(options)
    end

    # Updates an inbound folder
    # @param folder_id [Integer] The folder ID
    # @param [Hash] options The parameters to update
    # @option options [String] :name The folder name
    # @return [InboundFolder] Updated folder
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def update(folder_id, options)
      base_update(folder_id, options)
    end

    # Deletes an inbound folder along with all of its inboxes
    # @param folder_id [Integer] The folder ID
    # @return nil
    # @!macro api_errors
    def delete(folder_id)
      base_delete(folder_id)
    end

    private

    def base_path
      '/api/inbound/folders'
    end
  end
end
