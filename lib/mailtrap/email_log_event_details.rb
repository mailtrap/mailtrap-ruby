# frozen_string_literal: true

module Mailtrap
  # Type-specific event detail structs for EmailLogEvent. Use event_type to determine which details schema applies.
  # @see https://docs.mailtrap.io/developers/email-sending/email-logs
  module EmailLogEventDetails
    # For event_type = delivery
    Delivery = Struct.new(:sending_ip, :recipient_mx, :email_service_provider, keyword_init: true)

    # For event_type = open
    Open = Struct.new(:web_ip_address, keyword_init: true)

    # For event_type = click
    Click = Struct.new(:click_url, :web_ip_address, keyword_init: true)

    # For event_type = soft_bounce or bounce
    Bounce = Struct.new(
      :sending_ip,
      :recipient_mx,
      :email_service_provider,
      :email_service_provider_status,
      :email_service_provider_response,
      :bounce_category,
      keyword_init: true
    )

    # For event_type = spam
    Spam = Struct.new(:spam_feedback_type, keyword_init: true)

    # For event_type = unsubscribe
    Unsubscribe = Struct.new(:web_ip_address, keyword_init: true)

    # For event_type = suspension or reject
    Reject = Struct.new(:reject_reason, keyword_init: true)

    # For event_type = topic_unsubscribe or topic_resubscribe
    TopicSubscription = Struct.new(:web_ip_address, :subscription_topic_id, keyword_init: true)

    DETAIL_STRUCTS = {
      'delivery' => Delivery,
      'open' => Open,
      'click' => Click,
      'soft_bounce' => Bounce,
      'bounce' => Bounce,
      'spam' => Spam,
      'unsubscribe' => Unsubscribe,
      'suspension' => Reject,
      'reject' => Reject,
      'topic_unsubscribe' => TopicSubscription,
      'topic_resubscribe' => TopicSubscription
    }.freeze

    # Builds the appropriate detail struct from API response.
    # @param event_type [String] Event type (delivery, open, click, etc.)
    # @param hash [Hash] Symbol-keyed details from parsed JSON
    # @return [Delivery, Open, Click, Bounce, Spam, Unsubscribe, Reject, TopicSubscription, Hash, nil]
    #   For an event type not in DETAIL_STRUCTS, the details as returned, so a newer event type doesn't fail
    #   the whole message
    def self.build(event_type, hash)
      struct_class = DETAIL_STRUCTS[event_type.to_s]
      return hash unless struct_class

      attrs = hash.slice(*struct_class.members)
      struct_class.new(**attrs)
    end
  end
end
