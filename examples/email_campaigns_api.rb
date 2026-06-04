require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
email_campaigns = Mailtrap::EmailCampaignsAPI.new(account_id, client)

# Create a new Email Campaign (draft state)
email_campaign = email_campaigns.create(
  name: 'Spring Sale',
  mailsend_domain_id: 123,
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

# Get all Email Campaigns (paginated, newest first)
list = email_campaigns.list(per_page: 50, name: 'Spring')
# => #<struct Mailtrap::EmailCampaignsListResponse data=[#<struct Mailtrap::EmailCampaign ...>], pagination={...}>
list.data
# => [#<struct Mailtrap::EmailCampaign id=4567, name="Spring Sale", ...>]
list.pagination
# => {:token=>1, :prev_token=>nil, :next_token=>2, ...}

# Get a single Email Campaign
email_campaign = email_campaigns.get(email_campaign.id)
# => #<struct Mailtrap::EmailCampaign id=4567, name="Spring Sale", ...>

# Update an Email Campaign (partial; campaign must not be in a sending state)
email_campaigns.update(
  email_campaign.id,
  name: 'Spring Sale (updated)',
  delivery_mode: 'scheduled',
  scheduled_for: '2026-06-01T09:00:00.000Z',
  delivery_options: { emails_per_hour: 1000 },
  template_attributes: { id: 789, subject: 'New subject' }
)
# => #<struct Mailtrap::EmailCampaign id=4567, name="Spring Sale (updated)", ...>

# Get Email Campaign statistics
email_campaigns.stats(email_campaign.id)
# => #<struct Mailtrap::EmailCampaignStats delivery_count=1450, open_count=820, delivery_rate=0.9667, ...>

# Delete an Email Campaign (returns the deleted campaign)
email_campaigns.delete(email_campaign.id)
# => #<struct Mailtrap::EmailCampaign id=4567, name="Spring Sale (updated)", ...>
