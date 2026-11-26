# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Subscription Topic
  # @attr_reader id [Integer] The subscription topic ID
  # @attr_reader name [String] The topic name
  # @attr_reader description [String, nil] The topic description
  # @attr_reader domain_id [Integer, nil] ID of the sending domain the topic is limited to,
  #   as returned by the Domains endpoints; +nil+ when it covers every domain
  # @attr_reader deleted_at [String, nil] When the topic was deleted; set only on a deleted topic,
  #   which {SubscriptionTopicsAPI#get} still returns
  # @attr_reader created_at [String] The creation timestamp
  # @attr_reader updated_at [String] The last update timestamp
  SubscriptionTopic = Struct.new(
    :id,
    :name,
    :description,
    :domain_id,
    :deleted_at,
    :created_at,
    :updated_at,
    keyword_init: true
  )

  # Response from listing subscription topics (paginated)
  # @attr_reader data [Array<SubscriptionTopic>] Page of subscription topics, by ID
  # @attr_reader pagination [Hash] Page-token pagination metadata
  #   (+token+, +prev_token+, +next_token+, +first_url+, +prev_url+, +current_url+, +next_url+)
  SubscriptionTopicsListResponse = Struct.new(
    :data,
    :pagination,
    keyword_init: true
  )
end
