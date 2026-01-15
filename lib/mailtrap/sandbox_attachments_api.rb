# frozen_string_literal: true

require_relative 'base_api'
require_relative 'sandbox_attachment'

module Mailtrap
  class SandboxAttachmentsAPI
    include BaseAPI

    self.response_class = SandboxAttachment

    # Retrieves a specific sandbox attachment
    # @param inbox_id [Integer] The inbox ID
    # @param sandbox_message_id [Integer] The sandbox message ID
    # @param sandbox_attachment_id [Integer] The sandbox attachment ID
    # @return [SandboxAttachment] Sandbox attachment object
    # @!macro api_errors
    def get(inbox_id, sandbox_message_id, sandbox_attachment_id)
      response = client.get(
        "#{base_path}/inboxes/#{inbox_id}/messages/#{sandbox_message_id}/attachments/#{sandbox_attachment_id}"
      )
      handle_response(response)
    end

    # Lists all sandbox messages for the account, limited up to 30 at once
    # @param inbox_id [Integer] The inbox ID
    # @param sandbox_message_id [Integer] The sandbox message ID
    # @return [Array<SandboxAttachment>] Array of sandbox message objects
    # @!macro api_errors
    def list(inbox_id, sandbox_message_id)
      response = client.get("#{base_path}/inboxes/#{inbox_id}/messages/#{sandbox_message_id}/attachments")
      response.map { |item| handle_response(item) }
    end

    private

    def base_path
      "/api/accounts/#{account_id}"
    end
  end
end
