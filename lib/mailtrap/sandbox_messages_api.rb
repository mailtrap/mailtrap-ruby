# frozen_string_literal: true

require_relative 'base_api'
require_relative 'sandbox_message'

module Mailtrap
  class SandboxMessagesAPI
    include BaseAPI

    attr_reader :account_id, :inbox_id, :client

    self.supported_options = %i[is_read]

    self.response_class = SandboxMessage

    # @param account_id [Integer] The account ID
    # @param inbox_id [Integer] The inbox ID
    # @param client [Mailtrap::Client] The client instance
    # @raise [ArgumentError] If account_id is nil
    # @raise [ArgumentError] If inbox_id is nil
    def initialize(account_id, inbox_id, client = Mailtrap::Client.new)
      raise ArgumentError, 'inbox_id is required' if inbox_id.nil?

      @inbox_id = inbox_id

      super(account_id, client)
    end

    # Retrieves a specific sandbox message from inbox
    # @param message_id [Integer] The sandbox message ID
    # @return [SandboxMessage] Sandbox message object
    # @!macro api_errors
    def get(message_id)
      base_get(message_id)
    end

    # Deletes a sandbox message
    # @param message_id [Integer] The sandbox message ID
    # @return [SandboxMessage] Deleted Sandbox message object
    # @!macro api_errors
    def delete(message_id)
      base_delete(message_id)
    end

    # Updates an existing sandbox message
    # @param message_id [Integer] The sandbox message ID
    # @param options [Hash] The parameters to update
    # @return [SandboxMessage] Updated Sandbox message object
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def update(message_id, options)
      base_update(message_id, options)
    end

    # Lists all sandbox messages for the account, limited up to 30 at once
    # @param search [String] Search query string. Matches subject, to_email, and to_name.
    # @param last_id [Integer] If specified, a page of records before last_id is returned.
    # Overrides page if both are given.
    # @param page [Integer] Page number for paginated results.
    # @return [Array<SandboxMessage>] Array of sandbox message objects
    # @!macro api_errors
    def list(search: nil, last_id: nil, page: nil)
      raise ArgumentError, 'Provide either last_id or page, not both' unless last_id.nil? || page.nil?

      query_params = {}
      query_params[:search] = search unless search.nil?
      query_params[:last_id] = last_id unless last_id.nil?
      query_params[:page] = page unless page.nil?

      base_list(query_params)
    end

    # Forward message to an email address.
    # @param message_id [Integer] The sandbox message ID
    # @param email [String] The email to forward sandbox message to
    # @return [String] Forwarded message confirmation
    # @!macro api_errors
    def forward_message(message_id:, email:)
      client.post("#{base_path}/#{message_id}/forward", { email: email })
    end

    # Get message spam score
    # @param message_id [Integer] The sandbox message ID
    # @return [Hash] Spam report
    # @!macro api_errors
    def spam_score(message_id)
      client.get("#{base_path}/#{message_id}/spam_report")
    end

    # Get message HTML analysis
    # @param message_id [Integer] The sandbox message ID
    # @return [Hash] brief HTML report
    # @!macro api_errors
    def html_analysis(message_id)
      client.get("#{base_path}/#{message_id}/analyze")
    end

    # Get text message
    # @param message_id [Integer] The sandbox message ID
    # @return [String] text email body
    # @!macro api_errors
    def text_body(message_id)
      client.get("#{base_path}/#{message_id}/body.txt")
    end

    # Get raw message
    # @param message_id [Integer] The sandbox message ID
    # @return [String] raw email body
    # @!macro api_errors
    def raw_body(message_id)
      client.get("#{base_path}/#{message_id}/body.raw")
    end

    # Get message source
    # @param message_id [Integer] The sandbox message ID
    # @return [String] HTML source of a message.
    # @!macro api_errors
    def html_source(message_id)
      client.get("#{base_path}/#{message_id}/body.htmlsource")
    end

    # Get formatted HTML email body. Not applicable for plain text emails.
    # @param message_id [Integer] The sandbox message ID
    # @return [String] message body in html format.
    # @!macro api_errors
    def html_body(message_id)
      client.get("#{base_path}/#{message_id}/body.html")
    end

    # Get message as EML
    # @param message_id [Integer] The sandbox message ID
    # @return [String] mail message body in EML format.
    # @!macro api_errors
    def eml_body(message_id)
      client.get("#{base_path}/#{message_id}/body.eml")
    end

    # Get mail headers
    # @param message_id [Integer] The sandbox message ID
    # @return [Hash] mail headers of the message.
    # @!macro api_errors
    def mail_headers(message_id)
      client.get("#{base_path}/#{message_id}/mail_headers")
    end

    private

    def base_path
      "/api/accounts/#{account_id}/inboxes/#{inbox_id}/messages"
    end

    def wrap_request(options)
      { message: options }
    end
  end
end
