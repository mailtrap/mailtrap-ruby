# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for a paginated list of tracking opt-outs
  # @see https://docs.mailtrap.io/developers/management/tracking-opt-outs
  # @attr_reader data [Array<TrackingOptOut>] The tracking opt-outs on this page
  # @attr_reader last_id [String, nil] Cursor for the next page, or nil if this is the last page
  TrackingOptOutsListResponse = Struct.new(
    :data,
    :last_id,
    keyword_init: true
  )
end
