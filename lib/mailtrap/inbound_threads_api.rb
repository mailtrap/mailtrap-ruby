# frozen_string_literal: true

require_relative 'base_api'
require_relative 'inbound_thread'
require_relative 'inbound_thread_message'
require_relative 'inbound_attachment'
require_relative 'inbound_threads_list_response'

module Mailtrap
  class InboundThreadsAPI
    include BaseAPI

    self.response_class = InboundThread

    # Inbound is scoped to the token's account, so no account_id is required.
    # @param client [Mailtrap::Client] The client instance
    def initialize(client = Mailtrap::Client.new)
      @client = client
    end

    # Lists threads in an inbox (cursor-paginated)
    # @param inbox_id [Integer] The inbox ID
    # @param last_id [String, nil] Cursor from the previous response's +last_id+ for the next page
    # @return [InboundThreadsListResponse] data, total_count, and last_id
    # @!macro api_errors
    def list(inbox_id, last_id: nil)
      query_params = last_id ? { last_id: } : {}
      response = client.get(threads_path(inbox_id), query_params)

      InboundThreadsListResponse.new(
        data: Array(response[:data]).map { |item| build_thread(item) },
        total_count: response[:total_count],
        last_id: response[:last_id]
      )
    end

    # Fetches a single thread with its messages embedded (oldest first)
    # @param inbox_id [Integer] The inbox ID
    # @param thread_id [String] The thread ID
    # @return [InboundThread] Thread with messages
    # @!macro api_errors
    def get(inbox_id, thread_id)
      build_thread(client.get("#{threads_path(inbox_id)}/#{thread_id}"))
    end

    # Deletes a thread
    # @param inbox_id [Integer] The inbox ID
    # @param thread_id [String] The thread ID
    # @return nil
    # @!macro api_errors
    def delete(inbox_id, thread_id)
      client.delete("#{threads_path(inbox_id)}/#{thread_id}")
    end

    private

    def threads_path(inbox_id)
      "/api/inbound/inboxes/#{inbox_id}/threads"
    end

    def build_thread(hash)
      attrs = hash.slice(*InboundThread.members)
      attrs[:attachments] = build_attachments(attrs[:attachments]) if attrs[:attachments]
      attrs[:messages] = build_messages(attrs[:messages]) if attrs[:messages]

      InboundThread.new(**attrs)
    end

    def build_messages(messages)
      Array(messages).map do |message|
        attrs = message.slice(*InboundThreadMessage.members)
        attrs[:attachments] = build_attachments(attrs[:attachments]) if attrs[:attachments]

        InboundThreadMessage.new(**attrs)
      end
    end

    def build_attachments(attachments)
      Array(attachments).map do |attachment|
        InboundAttachment.new(**attachment.slice(*InboundAttachment.members))
      end
    end
  end
end
