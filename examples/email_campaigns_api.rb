require 'mailtrap'

client = Mailtrap::Client.new(api_key: 'your-api-key')
email_campaigns = Mailtrap::EmailCampaignsAPI.new(client)

# Create a new Email Campaign (always created in the draft state)
email_campaign = email_campaigns.create(
  name: 'Spring Sale',
  domain_id: 4321,
  from_display_name: 'Acme Marketing',
  from_local_part: 'news',
  reply_to: {
    display_name: 'Acme Support',
    local_part: 'support',
    domain: 'acme.com'
  },
  template_attributes: { subject: 'Spring is here — 30% off' }
)
# => #<struct Mailtrap::EmailCampaign id=4567, name="Spring Sale", current_state="draft", ...>

# Get all Email Campaigns (paginated, newest first; filter by name)
list = email_campaigns.list(per_page: 50, name: 'Spring')
# => #<struct Mailtrap::EmailCampaignsListResponse data=[#<struct Mailtrap::EmailCampaign ...>], pagination={...}>
list.data
# => [#<struct Mailtrap::EmailCampaign id=4567, name="Spring Sale", ...>]
list.pagination
# => {:token=>1, :prev_token=>nil, :next_token=>2, ...}

# Get a single Email Campaign
email_campaign = email_campaigns.get(email_campaign.id)
# => #<struct Mailtrap::EmailCampaign id=4567, name="Spring Sale", ...>

# Update a draft Email Campaign (partial; add the design and the audience)
email_campaigns.update(
  email_campaign.id,
  name: 'Spring Sale (updated)',
  template_attributes: {
    subject: 'New subject',
    body_html: '<html><body><h1>Hi {{first_name}}!</h1>' \
               '<p><a href="__unsubscribe_url__">Unsubscribe</a></p></body></html>',
    merge_tags: ['first_name']
  },
  delivery_mode: 'gradual',
  delivery_options: { emails_per_hour: 1000 },
  contact_list_ids: [55, 56],
  contact_segment_ids: [12]
)
# => #<struct Mailtrap::EmailCampaign id=4567, name="Spring Sale (updated)", ...>

# Schedule the draft Email Campaign to start sending at a future time
email_campaigns.schedule(email_campaign.id, '2026-06-01T09:00:00.000Z')
# => #<struct Mailtrap::EmailCampaign id=4567, current_state="scheduled", ...>

# Cancel the scheduled Email Campaign (returns it to the draft state)
email_campaigns.cancel(email_campaign.id)
# => #<struct Mailtrap::EmailCampaign id=4567, current_state="draft", ...>

# Start sending the draft Email Campaign immediately
email_campaigns.start(email_campaign.id)
# => #<struct Mailtrap::EmailCampaign id=4567, current_state="started", ...>

# Terminate a sending Email Campaign
email_campaigns.terminate(email_campaign.id)
# => #<struct Mailtrap::EmailCampaign id=4567, current_state="terminating", ...>

# Reset a scheduled Email Campaign back to draft
email_campaigns.reset(email_campaign.id)
# => #<struct Mailtrap::EmailCampaign id=4567, current_state="draft", ...>

# Get Email Campaign statistics (optionally narrow the aggregation window)
email_campaigns.stats(email_campaign.id, start_date: '2026-05-01', end_date: '2026-05-31')
# => #<struct Mailtrap::EmailCampaignStats delivery_count=1450, open_count=820, delivery_rate=0.9667, ...>

# Delete an Email Campaign (returns nil; the campaign must not be in a sending state)
email_campaigns.delete(email_campaign.id)
# => nil
