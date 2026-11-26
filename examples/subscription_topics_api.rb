require 'mailtrap'

client = Mailtrap::Client.new(api_key: 'your-api-key')
subscription_topics = Mailtrap::SubscriptionTopicsAPI.new(client)

# Subscription topics are created in the Mailtrap app; the API reads them, so that campaigns
# (subscription_topic_id) and contacts (subscription_topics) can refer to their IDs.
begin
  # Get the subscription topics (paginated, by ID; deleted topics are left out)
  list = subscription_topics.list(per_page: 50)
  # => #<struct Mailtrap::SubscriptionTopicsListResponse
  #      data=[#<struct Mailtrap::SubscriptionTopic ...>],
  #      pagination={:token=>1, :prev_token=>nil, :next_token=>2, ...}>
  list.data
  # => [#<struct Mailtrap::SubscriptionTopic
  #      id=12,
  #      name="Product updates",
  #      description="News about our product",
  #      domain_id=nil,
  #      deleted_at=nil,
  #      created_at="2026-11-01T10:00:00Z",
  #      updated_at="2026-11-02T10:00:00Z">]
  # domain_id is nil for a topic that covers every sending domain

  # Get the next page
  next_token = list.pagination[:next_token]
  subscription_topics.list(per_page: 50, token: next_token) if next_token

  # Get a single subscription topic; a deleted one is returned too, with deleted_at set
  topic = list.data.first
  subscription_topics.get(topic.id) if topic
  # => #<struct Mailtrap::SubscriptionTopic id=12, name="Product updates", ...>
rescue Mailtrap::RejectionError
  puts 'Subscription topics are not available for this account'
end
