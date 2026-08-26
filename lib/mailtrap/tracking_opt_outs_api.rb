# frozen_string_literal: true

require_relative 'base_api'
require_relative 'tracking_opt_out'
require_relative 'tracking_opt_outs_list_response'

module Mailtrap
  class TrackingOptOutsAPI
    include BaseAPI

    self.supported_options = %i[email domain_id].freeze

    self.response_class = TrackingOptOut

    # @param client [Mailtrap::Client] The client instance
    def initialize(client = Mailtrap::Client.new)
      @client = client
    end

    # Lists email addresses that have opted out of open and click tracking
    # @param email [String, nil] Filter by exact email address (case-insensitive)
    # @param start_time [String, nil] Only opt-outs created at or after this ISO 8601 timestamp
    # @param end_time [String, nil] Only opt-outs created at or before this ISO 8601 timestamp
    # @param last_id [String, nil] Cursor from the previous response's +last_id+ for the next page
    # @return [TrackingOptOutsListResponse] The page of tracking opt-outs and the next cursor
    # @!macro api_errors
    def list(email: nil, start_time: nil, end_time: nil, last_id: nil)
      query_params = {}
      query_params[:email] = email unless email.nil?
      query_params[:start_time] = start_time unless start_time.nil?
      query_params[:end_time] = end_time unless end_time.nil?
      query_params[:last_id] = last_id unless last_id.nil?

      response = client.get(base_path, query_params)

      TrackingOptOutsListResponse.new(
        data: Array(response[:data]).map { |item| build_entity(item, TrackingOptOut) },
        last_id: response[:last_id]
      )
    end

    # Adds an email address to the tracking opt-out list for a sending domain
    # @param [Hash] options The tracking opt-out attributes
    # @option options [String] :email Email address to opt out of tracking
    # @option options [Integer] :domain_id ID of the sending domain the opt-out applies to
    # @return [TrackingOptOut] Created tracking opt-out
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(options)
      validate_options!(options, supported_options)
      response = client.post(base_path, options)
      build_entity(response[:data], TrackingOptOut)
    end

    # Removes an email address from the tracking opt-out list
    # @param tracking_opt_out_id [String] The tracking opt-out UUID
    # @return [TrackingOptOut] The deleted tracking opt-out
    # @!macro api_errors
    def delete(tracking_opt_out_id)
      response = client.delete("#{base_path}/#{tracking_opt_out_id}")
      build_entity(response, TrackingOptOut)
    end

    private

    def base_path
      '/api/tracking_opt_outs'
    end
  end
end
