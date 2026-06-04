# frozen_string_literal: true

require_relative 'base_api'
require_relative 'email_campaign'

module Mailtrap
  class EmailCampaignsAPI
    include BaseAPI

    CREATE_OPTIONS = %i[
      name
      mailsend_domain_id
      from_display_name
      from_local_part
      reply_to
      template_attributes
    ].freeze

    UPDATE_OPTIONS = (CREATE_OPTIONS + %i[delivery_mode scheduled_for delivery_options]).freeze

    self.supported_options = CREATE_OPTIONS

    self.response_class = EmailCampaign

    # Lists email campaigns for the account, newest first
    # @param per_page [Integer, nil] Number of campaigns per page (max 100, default 50)
    # @param name [String, nil] Filter campaigns by name (case-insensitive partial match)
    # @param token [Integer, nil] Page number to retrieve (page-token pagination, default 1)
    # @return [EmailCampaignsListResponse] The page of campaigns and pagination metadata
    # @!macro api_errors
    def list(per_page: nil, name: nil, token: nil)
      query_params = {}
      query_params[:per_page] = per_page unless per_page.nil?
      query_params[:search] = name unless name.nil?
      query_params[:token] = token unless token.nil?

      response = client.get(base_path, query_params)

      EmailCampaignsListResponse.new(
        data: Array(response[:data]).map { |item| handle_response(item) },
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
    # @option options [Integer] :mailsend_domain_id ID of the verified sending domain (required)
    # @option options [String] :from_display_name Display name shown in the From header
    # @option options [String] :from_local_part Local part (before the @) of the From address
    # @option options [Hash] :reply_to Reply-To address parts (+display_name+, +local_part+, +domain+)
    # @option options [Hash] :template_attributes Template attributes (+subject+)
    # @return [EmailCampaign] Created email campaign
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(options)
      base_create(options, CREATE_OPTIONS)
    end

    # Updates an existing email campaign. The campaign must not be in a sending state.
    # Only the provided attributes are changed.
    # @param email_campaign_id [Integer] The email campaign ID
    # @param [Hash] options The parameters to update
    # @option options [String] :name Campaign name
    # @option options [Integer] :mailsend_domain_id ID of the verified sending domain
    # @option options [String] :from_display_name Display name shown in the From header
    # @option options [String] :from_local_part Local part (before the @) of the From address
    # @option options [String] :delivery_mode How the campaign is delivered (+immediate+ or +scheduled+)
    # @option options [String] :scheduled_for When to send (required when +delivery_mode+ is +scheduled+)
    # @option options [Hash] :delivery_options Delivery throttling options (+emails_per_hour+)
    # @option options [Hash] :reply_to Reply-To address parts (+display_name+, +local_part+, +domain+)
    # @option options [Hash] :template_attributes Template attributes (+id+ to update in place, +subject+)
    # @return [EmailCampaign] Updated email campaign
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def update(email_campaign_id, options)
      base_update(email_campaign_id, options, UPDATE_OPTIONS)
    end

    # Deletes an email campaign. The campaign must not be in a sending state.
    # The deleted campaign object is returned (200 + body, not 204).
    # @param email_campaign_id [Integer] The email campaign ID
    # @return [EmailCampaign] The deleted email campaign
    # @!macro api_errors
    def delete(email_campaign_id)
      response = client.delete("#{base_path}/#{email_campaign_id}")
      handle_response(response)
    end

    # Retrieves aggregated performance statistics for an email campaign
    # @param email_campaign_id [Integer] The email campaign ID
    # @return [EmailCampaignStats] Aggregated campaign statistics
    # @!macro api_errors
    def stats(email_campaign_id)
      response = client.get("#{base_path}/#{email_campaign_id}/stats")
      build_entity(response, EmailCampaignStats)
    end

    private

    def base_path
      '/api/email_campaigns'
    end

    def wrap_request(options)
      { email_campaign: options }
    end

    def handle_response(response)
      campaign = build_entity(response, response_class)
      campaign.stats = build_entity(response[:stats], EmailCampaignStats) if response[:stats]
      campaign
    end
  end
end
