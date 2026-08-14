# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Email Campaign Stats
  #
  # Aggregated campaign performance metrics. All counts and rates are +0+ when the
  # campaign has not been started.
  # @see https://api-docs.mailtrap.io/docs/mailtrap-api-docs/email-campaigns
  # @attr_reader delivery_count [Integer] Number of delivered messages
  # @attr_reader open_count [Integer] Number of opened messages
  # @attr_reader click_count [Integer] Number of clicked messages
  # @attr_reader bounce_count [Integer] Number of bounced messages
  # @attr_reader unsubscription_count [Integer] Number of unsubscriptions
  # @attr_reader sent_count [Integer] Number of sent messages
  # @attr_reader spam_count [Integer] Number of spam complaints
  # @attr_reader delivery_rate [Float] Share of sent messages that were delivered (0–1)
  # @attr_reader open_rate [Float] Share of delivered messages that were opened (0–1)
  # @attr_reader click_rate [Float] Share of delivered messages that were clicked (0–1)
  # @attr_reader bounce_rate [Float] Share of sent messages that bounced (0–1)
  # @attr_reader spam_rate [Float] Share of sent messages marked as spam (0–1)
  # @attr_reader unsubscription_rate [Float] Share of delivered messages that unsubscribed (0–1)
  EmailCampaignStats = Struct.new(
    :delivery_count,
    :open_count,
    :click_count,
    :bounce_count,
    :unsubscription_count,
    :sent_count,
    :spam_count,
    :delivery_rate,
    :open_rate,
    :click_rate,
    :bounce_rate,
    :spam_rate,
    :unsubscription_rate,
    keyword_init: true
  )

  # Data Transfer Object for Email Campaign
  # @see https://api-docs.mailtrap.io/docs/mailtrap-api-docs/email-campaigns
  # @attr_reader id [Integer] The email campaign ID
  # @attr_reader domain_id [Integer] ID of the sending domain used for the campaign,
  #   as returned by the Sending Domains endpoints
  # @attr_reader domain_name [String] Name of the sending domain used for the campaign
  # @attr_reader name [String] Campaign name
  # @attr_reader from_local_part [String] Local part (before the @) of the From address
  # @attr_reader from_display_name [String] Display name shown in the From header
  # @attr_reader reply_to [Hash, nil] Reply-To address parts (+display_name+, +local_part+, +domain+)
  # @attr_reader current_state [String] Lifecycle state (+draft+, +scheduled+, +started+, +queued+,
  #   +paused+, +terminating+, +under_review+, +finished+, +failed+, +failed_immediately+)
  # @attr_reader current_state_metadata [Hash, nil] Metadata about the most recent state transition
  #   (+reason+, +error+, +errors+ as an array of +{message, rcpt_index}+ objects, +scheduled_at+)
  # @attr_reader created_at [String] The creation timestamp
  # @attr_reader updated_at [String] The last update timestamp
  # @attr_reader last_started_at [String, nil] When the campaign was last started, or +nil+
  # @attr_reader last_started_at_date [String, nil] Date the campaign was last started, present only when started
  # @attr_reader recipient_total_count [Integer, nil] Total number of recipients,
  #   or +nil+ until the audience is resolved
  # @attr_reader contact_list_ids [Array<Integer>] IDs of the contact lists included in the campaign's audience
  # @attr_reader contact_segment_ids [Array<Integer>] IDs of the contact segments included in the campaign's audience
  # @attr_reader delivery_mode [String] How the campaign is delivered (+rapid+ or +gradual+)
  # @attr_reader delivery_options [Hash, nil] Delivery throttling options (+emails_per_hour+)
  # @attr_reader template [Hash, nil] The campaign template (+id+, +subject+, +merge_tags+,
  #   +body_html+, +body_text+; bodies are omitted on list responses)
  EmailCampaign = Struct.new(
    :id,
    :domain_id,
    :domain_name,
    :name,
    :from_local_part,
    :from_display_name,
    :reply_to,
    :current_state,
    :current_state_metadata,
    :created_at,
    :updated_at,
    :last_started_at,
    :last_started_at_date,
    :recipient_total_count,
    :contact_list_ids,
    :contact_segment_ids,
    :delivery_mode,
    :delivery_options,
    :template,
    keyword_init: true
  )

  # Response from listing email campaigns (paginated)
  # @see https://api-docs.mailtrap.io/docs/mailtrap-api-docs/email-campaigns
  # @attr_reader data [Array<EmailCampaign>] Page of email campaigns, newest first
  # @attr_reader pagination [Hash] Page-token pagination metadata
  #   (+token+, +prev_token+, +next_token+, +first_url+, +prev_url+, +current_url+, +next_url+)
  EmailCampaignsListResponse = Struct.new(
    :data,
    :pagination,
    keyword_init: true
  )
end
