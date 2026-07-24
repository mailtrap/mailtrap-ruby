# frozen_string_literal: true

require_relative 'base_api'
require_relative 'inbound_message'
require_relative 'inbound_attachment'
require_relative 'inbound_messages_list_response'
require_relative 'inbound_send_result'

module Mailtrap
  class InboundMessagesAPI
    include BaseAPI

    self.response_class = InboundMessage

    SEND_OPTIONS = %i[from to cc bcc reply_to text html category attachments headers custom_variables].freeze

    # Inbound is scoped to the token's account, so no account_id is required.
    # @param client [Mailtrap::Client] The client instance
    def initialize(client = Mailtrap::Client.new)
      @client = client
    end

    # Lists messages in an inbox (cursor-paginated)
    # @param inbox_id [Integer] The inbox ID
    # @param last_id [String, nil] Cursor from the previous response's +last_id+ for the next page
    # @return [InboundMessagesListResponse] data, total_count, and last_id
    # @!macro api_errors
    def list(inbox_id, last_id: nil)
      query_params = last_id ? { last_id: } : {}
      response = client.get(messages_path(inbox_id), query_params)

      InboundMessagesListResponse.new(
        data: Array(response[:data]).map { |item| build_message(item) },
        total_count: response[:total_count],
        last_id: response[:last_id]
      )
    end

    # Fetches a single message with its full body and attachment download URLs
    # @param inbox_id [Integer] The inbox ID
    # @param message_id [String] The message ID
    # @return [InboundMessage] Message details
    # @!macro api_errors
    def get(inbox_id, message_id)
      build_message(client.get("#{messages_path(inbox_id)}/#{message_id}"))
    end

    # Deletes a message
    # @param inbox_id [Integer] The inbox ID
    # @param message_id [String] The message ID
    # @return nil
    # @!macro api_errors
    def delete(inbox_id, message_id)
      client.delete("#{messages_path(inbox_id)}/#{message_id}")
    end

    # Replies to a message (sends to the original sender)
    # @param inbox_id [Integer] The inbox ID
    # @param message_id [String] The message ID
    # @param [Hash] options The send parameters (see {SEND_OPTIONS})
    # @return [InboundSendResult] The sent message IDs
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def reply(inbox_id, message_id, options)
      send_action(inbox_id, message_id, 'reply', options)
    end

    # Replies to a message and copies the original's other recipients
    # @param (see #reply)
    # @return [InboundSendResult] The sent message IDs
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def reply_all(inbox_id, message_id, options)
      send_action(inbox_id, message_id, 'reply_all', options)
    end

    # Forwards a message to new recipients
    # @param (see #reply)
    # @return [InboundSendResult] The sent message IDs
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided, or if no +to+ recipient is given
    def forward(inbox_id, message_id, options)
      raise ArgumentError, 'to is required for forward' if Array(options[:to]).empty?

      send_action(inbox_id, message_id, 'forward', options)
    end

    private

    def messages_path(inbox_id)
      "/api/inbound/inboxes/#{inbox_id}/messages"
    end

    def send_action(inbox_id, message_id, action, options)
      validate_options!(options, SEND_OPTIONS)
      response = client.post("#{messages_path(inbox_id)}/#{message_id}/#{action}", options)

      InboundSendResult.new(message_ids: response[:message_ids])
    end

    def build_message(hash)
      attrs = hash.slice(*InboundMessage.members)
      attrs[:attachments] = build_attachments(attrs[:attachments]) if attrs[:attachments]

      InboundMessage.new(**attrs)
    end

    def build_attachments(attachments)
      Array(attachments).map do |attachment|
        InboundAttachment.new(**attachment.slice(*InboundAttachment.members))
      end
    end
  end
end
