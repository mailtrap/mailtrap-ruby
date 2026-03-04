# frozen_string_literal: true

require_relative 'base_api'
require_relative 'sending_stats'
require_relative 'sending_stat_group'

module Mailtrap
  class StatsAPI
    include BaseAPI

    ARRAY_FILTERS = %i[sending_domain_ids sending_streams categories email_service_providers].freeze
    GROUP_KEYS = {
      'domains' => :sending_domain_id,
      'categories' => :category,
      'email_service_providers' => :email_service_provider,
      'date' => :date
    }.freeze

    # Get aggregated sending stats
    # @param start_date [String] Start date for the stats period (required)
    # @param end_date [String] End date for the stats period (required)
    # @param sending_domain_ids [Array<Integer>] Filter by sending domain IDs
    # @param sending_streams [Array<String>] Filter by sending streams
    # @param categories [Array<String>] Filter by categories
    # @param email_service_providers [Array<String>] Filter by email service providers
    # @return [SendingStats] Aggregated sending stats
    # @!macro api_errors
    def get(start_date:, end_date:, sending_domain_ids: nil, sending_streams: nil, categories: nil, # rubocop:disable Metrics/ParameterLists
            email_service_providers: nil)
      query_params = build_query_params(
        start_date, end_date,
        { sending_domain_ids:, sending_streams:, categories:, email_service_providers: }
      )
      response = client.get(base_path, query_params)
      build_entity(response, SendingStats)
    end

    # Get sending stats grouped by domains
    # @param start_date [String] Start date for the stats period (required)
    # @param end_date [String] End date for the stats period (required)
    # @param sending_domain_ids [Array<Integer>] Filter by sending domain IDs
    # @param sending_streams [Array<String>] Filter by sending streams
    # @param categories [Array<String>] Filter by categories
    # @param email_service_providers [Array<String>] Filter by email service providers
    # @return [Array<SendingStatGroup>] Array of SendingStatGroup structs with sending_domain_id and stats
    # @!macro api_errors
    def by_domains(start_date:, end_date:, sending_domain_ids: nil, sending_streams: nil, categories: nil, # rubocop:disable Metrics/ParameterLists
                   email_service_providers: nil)
      grouped_stats('domains', start_date, end_date,
                    { sending_domain_ids:, sending_streams:, categories:, email_service_providers: })
    end

    # Get sending stats grouped by categories
    # @param start_date [String] Start date for the stats period (required)
    # @param end_date [String] End date for the stats period (required)
    # @param sending_domain_ids [Array<Integer>] Filter by sending domain IDs
    # @param sending_streams [Array<String>] Filter by sending streams
    # @param categories [Array<String>] Filter by categories
    # @param email_service_providers [Array<String>] Filter by email service providers
    # @return [Array<SendingStatGroup>] Array of SendingStatGroup structs with category and stats
    # @!macro api_errors
    def by_categories(start_date:, end_date:, sending_domain_ids: nil, sending_streams: nil, categories: nil, # rubocop:disable Metrics/ParameterLists
                      email_service_providers: nil)
      grouped_stats('categories', start_date, end_date,
                    { sending_domain_ids:, sending_streams:, categories:, email_service_providers: })
    end

    # Get sending stats grouped by email service providers
    # @param start_date [String] Start date for the stats period (required)
    # @param end_date [String] End date for the stats period (required)
    # @param sending_domain_ids [Array<Integer>] Filter by sending domain IDs
    # @param sending_streams [Array<String>] Filter by sending streams
    # @param categories [Array<String>] Filter by categories
    # @param email_service_providers [Array<String>] Filter by email service providers
    # @return [Array<SendingStatGroup>] Array of SendingStatGroup structs with email_service_provider and stats
    # @!macro api_errors
    def by_email_service_providers(start_date:, end_date:, sending_domain_ids: nil, sending_streams: nil, # rubocop:disable Metrics/ParameterLists
                                   categories: nil, email_service_providers: nil)
      grouped_stats('email_service_providers', start_date, end_date,
                    { sending_domain_ids:, sending_streams:, categories:, email_service_providers: })
    end

    # Get sending stats grouped by date
    # @param start_date [String] Start date for the stats period (required)
    # @param end_date [String] End date for the stats period (required)
    # @param sending_domain_ids [Array<Integer>] Filter by sending domain IDs
    # @param sending_streams [Array<String>] Filter by sending streams
    # @param categories [Array<String>] Filter by categories
    # @param email_service_providers [Array<String>] Filter by email service providers
    # @return [Array<SendingStatGroup>] Array of SendingStatGroup structs with date and stats
    # @!macro api_errors
    def by_date(start_date:, end_date:, sending_domain_ids: nil, sending_streams: nil, categories: nil, # rubocop:disable Metrics/ParameterLists
                email_service_providers: nil)
      grouped_stats('date', start_date, end_date,
                    { sending_domain_ids:, sending_streams:, categories:, email_service_providers: })
    end

    private

    def grouped_stats(group, start_date, end_date, filters)
      query_params = build_query_params(start_date, end_date, filters)
      response = client.get("#{base_path}/#{group}", query_params)
      group_key = GROUP_KEYS.fetch(group)

      response.map do |item|
        SendingStatGroup.new(
          name: group_key,
          value: item[group_key],
          stats: build_entity(item[:stats], SendingStats)
        )
      end
    end

    def build_query_params(start_date, end_date, filters)
      params = { start_date: start_date, end_date: end_date }

      ARRAY_FILTERS.each do |filter_key|
        values = filters[filter_key]
        params["#{filter_key}[]"] = values if values
      end

      params
    end

    def base_path
      "/api/accounts/#{account_id}/stats"
    end
  end
end
