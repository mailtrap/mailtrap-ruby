# frozen_string_literal: true

require_relative 'base_api'
require_relative 'deprecation'
require_relative 'sandbox_attachment'

module Mailtrap
  class SandboxAttachmentsAPI
    include BaseAPI

    attr_reader :sandbox_id, :sandbox_message_id

    self.response_class = SandboxAttachment

    # @param account_id [Integer] The account ID
    # @param sandbox_id [Integer] The sandbox ID
    # @param sandbox_message_id [Integer] The message ID
    # @param client [Mailtrap::Client] The client instance
    # @raise [ArgumentError] If account_id is nil
    # @raise [ArgumentError] If sandbox_id is nil
    def initialize(account_id, sandbox_id, sandbox_message_id, client = Mailtrap::Client.new)
      raise ArgumentError, 'sandbox_id is required' if sandbox_id.nil?
      raise ArgumentError, 'sandbox_message_id is required' if sandbox_message_id.nil?

      @sandbox_id = sandbox_id
      @sandbox_message_id = sandbox_message_id

      super(account_id, client)
    end

    # @deprecated Use {#sandbox_id} instead.
    # @return [Integer] The sandbox ID
    def inbox_id
      Deprecation.warn('Mailtrap::SandboxAttachmentsAPI#inbox_id', 'Mailtrap::SandboxAttachmentsAPI#sandbox_id')
      sandbox_id
    end

    # Retrieves a specific sandbox attachment
    # @param sandbox_attachment_id [Integer] The sandbox attachment ID
    # @return [SandboxAttachment] Sandbox attachment object
    # @!macro api_errors
    def get(sandbox_attachment_id)
      base_get(sandbox_attachment_id)
    end

    # Lists all sandbox attachments for a message, limited up to 30 at once
    # @return [Array<SandboxAttachment>] Array of sandbox attachment objects
    # @!macro api_errors
    def list
      base_list
    end

    private

    def base_path
      "/api/accounts/#{account_id}/inboxes/#{sandbox_id}/messages/#{sandbox_message_id}/attachments"
    end
  end
end
