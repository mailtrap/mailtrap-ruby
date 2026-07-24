# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for a paginated list of inbound threads
  # @see https://docs.mailtrap.io/developers/inbound
  # @attr_reader data [Array<InboundThread>] The threads on this page
  # @attr_reader total_count [Integer] Total number of threads in the inbox
  # @attr_reader last_id [String, nil] Cursor for the next page, or nil if this is the last page
  InboundThreadsListResponse = Struct.new(
    :data,
    :total_count,
    :last_id,
    keyword_init: true
  )
end
