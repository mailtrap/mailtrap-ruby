# frozen_string_literal: true

require_relative 'base_api'
require_relative 'email_log_message'
require_relative 'email_log_event'
require_relative 'email_log_event_details'
require_relative 'email_logs_list_response'

module Mailtrap
  class EmailLogsAPI
    include BaseAPI

    self.response_class = EmailLogMessage

    # Lists email logs with optional filters and cursor-based pagination.
    #
    # @param filters [Hash, nil] Optional filters. Top-level date keys use string values (ISO 8601);
    #   other keys use +{ operator:, value: }+. +value+ can be a single value or an Array for
    #   operators that accept multiple values (e.g. +equal+, +not_equal+, +ci_equal+, +ci_not_equal+).
    #   Examples:
    #   +{ sent_after: "2025-01-01T00:00:00Z", sent_before: "2025-01-31T23:59:59Z" }+
    #   +{ to: { operator: "ci_equal", value: "recipient@example.com" } }+
    #   +{ category: { operator: "equal", value: ["Welcome Email", "Transactional Email"] } }+
    # @param search_after [String, nil] Message UUID cursor for the next page (from previous +next_page_cursor+)
    # @return [EmailLogsListResponse] messages, total_count, and next_page_cursor
    # @!macro api_errors
    def list(filters: nil, search_after: nil)
      query_params = build_list_query_params(filters:, search_after:)

      response = client.get(base_path, query_params)

      build_list_response(response)
    end

    # Iterates over all email log messages matching the filters, automatically fetching each page.
    # Use this when you want to process every message without manually handling +next_page_cursor+.
    #
    # @param filters [Hash, nil] Same as +list+
    # @yield [EmailLogMessage] Gives each message from every page when a block is given.
    # @return [Enumerator<EmailLogMessage>] if no block given; otherwise the result of the block
    # @!macro api_errors
    def list_each(filters: nil, &block)
      first_page = nil
      fetch_first_page = -> { first_page ||= list(filters: filters) }
      enum = Enumerator.new(-> { fetch_first_page.call.total_count }) do |yielder|
        response = fetch_first_page.call
        loop do
          response.messages.each { |message| yielder << message }
          break if response.next_page_cursor.nil?

          response = list(filters: filters, search_after: response.next_page_cursor)
        end
      end

      block ? enum.each(&block) : enum
    end

    # Fetches a single email log message by ID.
    #
    # @param sending_message_id [String] Message UUID
    # @return [EmailLogMessage] Message with events and raw_message_url when available
    # @!macro api_errors
    def get(sending_message_id)
      base_get(sending_message_id)
    end

    private

    def base_path
      "/api/accounts/#{account_id}/email_logs"
    end

    def build_list_query_params(filters:, search_after:)
      {}.tap do |params|
        params[:search_after] = search_after if search_after
        params.merge!(flatten_filters(filters))
      end
    end

    # Flattens a filters Hash into query param keys expected by the API (deepObject style).
    # Scalar values => filters[key]; Hashes with :operator/:value => filters[key][operator], filters[key][value].
    # When :value is an Array, the key is repeated (e.g. filters[category][value]=A&filters[category][value]=B)
    # for operators that accept multiple values (e.g. equal, not_equal, ci_equal, ci_not_equal).
    def flatten_filters(filters)
      return {} if filters.nil? || filters.empty?

      filters.each_with_object({}) do |(key, value), result|
        if value.is_a?(Hash)
          flatten_filter_hash(key, value, result)
        else
          result["filters[#{key}]"] = value.to_s
        end
      end
    end

    def flatten_filter_hash(parent_key, hash, result)
      hash.each do |key, value|
        if value.is_a?(Array)
          result["filters[#{parent_key}][#{key}][]"] = value.map(&:to_s)
        else
          result["filters[#{parent_key}][#{key}]"] = value.to_s
        end
      end
    end

    def build_list_response(response)
      EmailLogsListResponse.new(
        messages: Array(response[:messages]).map { |item| handle_response(item) },
        total_count: response[:total_count],
        next_page_cursor: response[:next_page_cursor]
      )
    end

    def handle_response(response)
      build_message_entity(response)
    end

    def build_message_entity(hash)
      attrs = hash.slice(*EmailLogMessage.members)
      attrs[:events] = build_events(attrs[:events]) if attrs[:events]

      EmailLogMessage.new(**attrs)
    end

    def build_events(events_array)
      Array(events_array).map do |e|
        EmailLogEvent.new(
          event_type: e[:event_type],
          created_at: e[:created_at],
          details: EmailLogEventDetails.build(e[:event_type], e[:details])
        )
      end
    end
  end
end
