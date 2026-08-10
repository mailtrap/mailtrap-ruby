# frozen_string_literal: true

require_relative 'base_api'
require_relative 'email_campaign'

module Mailtrap
  class EmailCampaignsAPI
    include BaseAPI

    self.supported_options = %i[
      name
      domain_id
      from_display_name
      from_local_part
      reply_to
      template_attributes
      delivery_mode
      delivery_options
      contact_list_ids
      contact_segment_ids
    ].freeze

    self.response_class = EmailCampaign

    attr_reader :client

    # @param client [Mailtrap::Client] The client instance
    def initialize(client = Mailtrap::Client.new)
      @client = client
    end

    # Lists email campaigns for the account, newest first
    # @param per_page [Integer, nil] Number of campaigns per page (max 100, default 50)
    # @param search [String, nil] Filter campaigns by name
    # @param token [Integer, nil] Page number to retrieve (page-token pagination, default 1)
    # @return [EmailCampaignsListResponse] The page of campaigns and pagination metadata
    # @!macro api_errors
    def list(per_page: nil, search: nil, token: nil)
      query_params = {}
      query_params[:per_page] = per_page unless per_page.nil?
      query_params[:search] = search unless search.nil?
      query_params[:token] = token unless token.nil?

      response = client.get(base_path, query_params)

      EmailCampaignsListResponse.new(
        data: Array(response[:data]).map { |item| build_entity(item, response_class) },
        pagination: response[:pagination]
      )
    end

    # Retrieves a specific email campaign
    # @param email_campaign_id [Integer] The email campaign ID
    # @return [EmailCampaign] Email campaign object
    # @!macro api_errors
    def get(email_campaign_id)
      base_get(email_campaign_id)
    end

    # Creates a new email campaign in the +draft+ state
    # @param [Hash] options The parameters to create
    # @option options [String] :name Campaign name (required)
    # @option options [Integer] :domain_id ID of the verified sending domain (required),
    #   as returned by the Sending Domains endpoints
    # @option options [String] :from_display_name Display name shown in the From header
    # @option options [String] :from_local_part Local part (before the @) of the From address (required)
    # @option options [Hash] :reply_to Reply-To address parts (+display_name+, +local_part+, +domain+)
    # @option options [Hash] :template_attributes Template attributes (+subject+ (required),
    #   +body_html+, +body_text+, +merge_tags+)
    # @option options [String] :delivery_mode How the campaign is delivered (+rapid+ or +gradual+)
    # @option options [Hash] :delivery_options Delivery throttling options (+emails_per_hour+),
    #   applies when +delivery_mode+ is +gradual+
    # @option options [Array<Integer>] :contact_list_ids IDs of contact lists to send to
    # @option options [Array<Integer>] :contact_segment_ids IDs of contact segments to send to
    # @return [EmailCampaign] Created email campaign
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(options)
      base_create(options)
    end

    # Updates an existing +draft+ email campaign. Only the provided attributes are changed;
    # +template_attributes+ sub-fields are also updated partially, in place.
    # @param email_campaign_id [Integer] The email campaign ID
    # @param [Hash] options The parameters to update; accepts the same fields as {#create}
    # @option options [String] :name Campaign name
    # @option options [Integer] :domain_id ID of the verified sending domain,
    #   as returned by the Sending Domains endpoints
    # @option options [String] :from_display_name Display name shown in the From header
    # @option options [String] :from_local_part Local part (before the @) of the From address
    # @option options [Hash] :reply_to Reply-To address parts (+display_name+, +local_part+, +domain+)
    # @option options [Hash] :template_attributes Template attributes (+subject+, +body_html+,
    #   +body_text+, +merge_tags+)
    # @option options [String] :delivery_mode How the campaign is delivered (+rapid+ or +gradual+)
    # @option options [Hash] :delivery_options Delivery throttling options (+emails_per_hour+),
    #   applies when +delivery_mode+ is +gradual+
    # @option options [Array<Integer>] :contact_list_ids IDs of contact lists to send to
    # @option options [Array<Integer>] :contact_segment_ids IDs of contact segments to send to
    # @return [EmailCampaign] Updated email campaign
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def update(email_campaign_id, options)
      base_update(email_campaign_id, options)
    end

    # Deletes an email campaign. The campaign must not be in a sending state.
    # @param email_campaign_id [Integer] The email campaign ID
    # @return [nil]
    # @!macro api_errors
    def delete(email_campaign_id)
      base_delete(email_campaign_id)
    end

    # Starts sending a +draft+ campaign immediately
    # @param email_campaign_id [Integer] The email campaign ID
    # @return [EmailCampaign] The started email campaign
    # @!macro api_errors
    def start(email_campaign_id)
      perform_action(email_campaign_id, :start)
    end

    # Schedules a +draft+ campaign to start sending at a future time.
    # The time is reported back in +current_state_metadata.scheduled_at+.
    # @param email_campaign_id [Integer] The email campaign ID
    # @param datetime [String] When to send the campaign (ISO 8601); must be in the future
    #   and no more than 1 month ahead
    # @return [EmailCampaign] The scheduled email campaign
    # @!macro api_errors
    def schedule(email_campaign_id, datetime)
      perform_action(email_campaign_id, :schedule, { datetime: })
    end

    # Cancels a +scheduled+ campaign, returning it to the +draft+ state
    # @param email_campaign_id [Integer] The email campaign ID
    # @return [EmailCampaign] The cancelled email campaign
    # @!macro api_errors
    def cancel(email_campaign_id)
      perform_action(email_campaign_id, :cancel)
    end

    # Terminates a campaign that is currently sending (+started+, +queued+, or +paused+),
    # aborting the in-flight send
    # @param email_campaign_id [Integer] The email campaign ID
    # @return [EmailCampaign] The terminated email campaign
    # @!macro api_errors
    def terminate(email_campaign_id)
      perform_action(email_campaign_id, :terminate)
    end

    # Resets a +scheduled+ campaign back to the +draft+ state
    # @param email_campaign_id [Integer] The email campaign ID
    # @return [EmailCampaign] The reset email campaign
    # @!macro api_errors
    def reset(email_campaign_id)
      perform_action(email_campaign_id, :reset)
    end

    # Retrieves aggregated performance statistics for an email campaign.
    # By default statistics are aggregated since the campaign was last started.
    # @param email_campaign_id [Integer] The email campaign ID
    # @param start_date [String, nil] Start of the aggregation window (inclusive), +YYYY-MM-DD+
    # @param end_date [String, nil] End of the aggregation window (inclusive), +YYYY-MM-DD+
    # @return [EmailCampaignStats] Aggregated campaign statistics
    # @!macro api_errors
    def stats(email_campaign_id, start_date: nil, end_date: nil)
      query_params = {}
      query_params[:start_date] = start_date unless start_date.nil?
      query_params[:end_date] = end_date unless end_date.nil?

      response = client.get("#{base_path}/#{email_campaign_id}/stats", query_params)
      build_entity(response[:data], EmailCampaignStats)
    end

    private

    def perform_action(email_campaign_id, action, body = nil)
      response = client.post("#{base_path}/#{email_campaign_id}/#{action}", body)
      handle_response(response)
    end

    def base_path
      '/api/email_campaigns'
    end

    def handle_response(response)
      build_entity(response[:data], response_class)
    end
  end
end
