# frozen_string_literal: true

require_relative 'base_api'
require_relative 'subscription_topic'

module Mailtrap
  # Read-only: subscription topics are managed in the Mailtrap app. Use a topic's ID as
  # +subscription_topic_id+ on email campaigns and in contacts' +subscription_topics+.
  class SubscriptionTopicsAPI
    include BaseAPI

    self.response_class = SubscriptionTopic

    # @param client [Mailtrap::Client] The client instance
    def initialize(client = Mailtrap::Client.new)
      @client = client
    end

    # Lists the account's subscription topics by ID, one page at a time; deleted topics are left out.
    # Pass +pagination[:next_token]+ with the same +per_page+ to get the next page.
    # @param per_page [Integer, nil] Number of topics per page (max 100, default 50)
    # @param token [Integer, nil] Page number to retrieve (page-token pagination, default 1)
    # @return [SubscriptionTopicsListResponse] The page of topics and pagination metadata
    # @!macro api_errors
    def list(per_page: nil, token: nil)
      query_params = {}
      query_params[:per_page] = per_page unless per_page.nil?
      query_params[:token] = token unless token.nil?

      response = client.get(base_path, query_params)

      SubscriptionTopicsListResponse.new(
        data: Array(response[:data]).map { |item| build_entity(item, response_class) },
        pagination: response[:pagination]
      )
    end

    # Retrieves a specific subscription topic, including a deleted one
    # @param subscription_topic_id [Integer] The subscription topic ID
    # @return [SubscriptionTopic] Subscription topic object
    # @!macro api_errors
    def get(subscription_topic_id)
      base_get(subscription_topic_id)
    end

    private

    def base_path
      '/api/subscription_topics'
    end

    def handle_response(response)
      build_entity(response[:data], response_class)
    end
  end
end
