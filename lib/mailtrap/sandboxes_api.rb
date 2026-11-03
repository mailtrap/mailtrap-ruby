# frozen_string_literal: true

require_relative 'base_api'
require_relative 'sandbox'

module Mailtrap
  class SandboxesAPI
    include BaseAPI

    self.supported_options = %i[name]
    self.response_class = Sandbox

    # Lists all sandboxes for the account
    # @return [Array<Sandbox>] Array of sandboxes
    # @!macro api_errors
    def list
      base_list
    end

    # Retrieves a specific sandbox
    # @param sandbox_id [Integer] The sandbox identifier
    # @return [Sandbox] Sandbox object
    # @!macro api_errors
    def get(sandbox_id)
      base_get(sandbox_id)
    end

    # Creates a new sandbox
    # @param [Hash] options The parameters to create
    # @option options [String] :name The sandbox name
    # @return [Sandbox] Created sandbox object
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(options)
      validate_options!(options, supported_options + [:project_id])
      response = client.post("/api/accounts/#{account_id}/projects/#{options[:project_id]}/inboxes",
                             wrap_request(options))
      handle_response(response)
    end

    # Deletes a sandbox
    # @param sandbox_id [Integer] The sandbox identifier
    # @return nil
    # @!macro api_errors
    def delete(sandbox_id)
      base_delete(sandbox_id)
    end

    # Updates an existing sandbox
    # @param sandbox_id [Integer] The sandbox identifier
    # @param [Hash] options The parameters to update
    # @option options [String] :name The sandbox name
    # @option options [String] :email_username The sandbox email username
    # @return [Sandbox] Updated sandbox object
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def update(sandbox_id, options)
      base_update(sandbox_id, options, supported_options + [:email_username])
    end

    # Delete all messages (emails) from the sandbox
    # @param sandbox_id [Integer] The sandbox identifier
    # @return [Sandbox] Updated sandbox object
    # @!macro api_errors
    def clean(sandbox_id)
      response = client.patch("#{base_path}/#{sandbox_id}/clean")
      handle_response(response)
    end

    # Mark all messages in the sandbox as read
    # @param sandbox_id [Integer] The sandbox identifier
    # @return [Sandbox] Updated sandbox object
    # @!macro api_errors
    def mark_as_read(sandbox_id)
      response = client.patch("#{base_path}/#{sandbox_id}/all_read")
      handle_response(response)
    end

    # Reset SMTP credentials of the sandbox
    # @param sandbox_id [Integer] The sandbox identifier
    # @return [Sandbox] Updated sandbox object
    # @!macro api_errors
    def reset_credentials(sandbox_id)
      response = client.patch("#{base_path}/#{sandbox_id}/reset_credentials")
      handle_response(response)
    end

    # Turn the email address of the sandbox on/off
    # @param sandbox_id [Integer] The sandbox identifier
    # @return [Sandbox] Updated sandbox object
    # @!macro api_errors
    def toggle_email_username(sandbox_id)
      response = client.patch("#{base_path}/#{sandbox_id}/toggle_email_username")
      handle_response(response)
    end

    # Reset username of email address per sandbox
    # @param sandbox_id [Integer] The sandbox identifier
    # @return [Sandbox] Updated sandbox object
    # @!macro api_errors
    def reset_email_username(sandbox_id)
      response = client.patch("#{base_path}/#{sandbox_id}/reset_email_username")
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
