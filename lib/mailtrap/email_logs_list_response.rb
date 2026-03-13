# frozen_string_literal: true

module Mailtrap
  # Response from listing email logs (paginated)
  # @see https://docs.mailtrap.io/developers/email-sending/email-logs
  # @attr_reader messages [Array<EmailLogMessage>] Page of message summaries
  # @attr_reader total_count [Integer] Total number of messages matching filters
  # @attr_reader next_page_cursor [String, nil] Message UUID to use as search_after for next page, or nil
  EmailLogsListResponse = Struct.new(
    :messages,
    :total_count,
    :next_page_cursor,
    keyword_init: true
  )
end
