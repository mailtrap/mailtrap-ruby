# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Tracking Opt-out
  # @see https://docs.mailtrap.io/developers/management/tracking-opt-outs
  # @attr_reader id [String] The tracking opt-out UUID
  # @attr_reader email [String] The email address opted out of tracking
  # @attr_reader created_at [String] The creation timestamp
  # @attr_reader domain_name [String, nil] Sending domain the tracking opt-out applies to
  TrackingOptOut = Struct.new(
    :id,
    :email,
    :created_at,
    :domain_name,
    keyword_init: true
  )
end
