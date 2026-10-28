# frozen_string_literal: true

require_relative 'base_api'
require_relative 'stats_query_params'
require_relative 'marketing_stats'

module Mailtrap
  class MarketingStatsAPI
    include BaseAPI
    include StatsQueryParams

    # @param client [Mailtrap::Client] The client instance
    def initialize(client = Mailtrap::Client.new)
      @client = client
    end

    # Get aggregated Email Marketing stats: campaigns and automations together, the same numbers
    # as Email Marketing > Stats Overview in the app. Email API/SMTP traffic is reported by {StatsAPI}.
    # @param start_date [String, Date, Time] Start of the period, inclusive (required)
    # @param end_date [String, Date, Time] End of the period, inclusive (required)
    # @param sending_domain_ids [Array<Integer>] Filter by sending domain IDs
    # @param sources [Array<String>] Filter by source: +campaigns+ or +automations+;
    #   omit it, or pass both, to include campaigns and automations together
    # @param email_service_providers [Array<String>] Filter by recipient email service providers
    # @return [MarketingStats] Aggregated Email Marketing stats
    # @!macro api_errors
    # @raise [ArgumentError] If a date is not a Date, Time, or String in +YYYY-MM-DD+ format
    def get(start_date:, end_date:, sending_domain_ids: nil, sources: nil, email_service_providers: nil)
      query_params = build_query_params(
        start_date, end_date,
        { sending_domain_ids:, sources:, email_service_providers: }
      )
      response = client.get(base_path, query_params)
      build_entity(response[:data], MarketingStats)
    end

    private

    def base_path
      '/api/marketing/stats'
    end
  end
end
