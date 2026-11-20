require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
webhooks_api = Mailtrap::WebhooksAPI.new(account_id, client)

# Create an `email_sending` webhook
webhook = webhooks_api.create(
  url: 'https://example.com/mailtrap/webhooks',
  webhook_type: 'email_sending',
  payload_format: 'json',
  sending_stream: 'transactional',
  event_types: %w[delivery bounce],
  domain_id: 435
)
# => #<struct Mailtrap::Webhook id=1, url="https://example.com/mailtrap/webhooks", ..., signing_secret="a1b2c3...">

# Event types: delivery, soft_bounce, bounce, suspension, unsubscribe, open, spam_complaint, click,
# reject and subscription_preferences_update. The last one, sent when a recipient changes their
# subscription topic preferences, is available only on `campaigns` webhooks and on `email_sending`
# webhooks of the `bulk` stream.

# Create a `campaigns` webhook
webhooks_api.create(
  url: 'https://example.com/mailtrap/campaigns',
  webhook_type: 'campaigns',
  payload_format: 'json',
  event_types: %w[unsubscribe subscription_preferences_update]
)

# Create an `audit_log` webhook
webhooks_api.create(
  url: 'https://example.com/mailtrap/audit-log',
  webhook_type: 'audit_log'
)

# Create an `inbound_receiving` webhook (linked to an inbound inbox)
webhooks_api.create(
  url: 'https://example.com/mailtrap/inbound',
  webhook_type: 'inbound_receiving',
  payload_format: 'json',
  inbound_inbox_id: 42
)

# List all webhooks
webhooks_api.list
# => [#<struct Mailtrap::Webhook id=1, ...>, #<struct Mailtrap::Webhook id=2, ...>]

# Get a single webhook
webhooks_api.get(webhook.id)
# => #<struct Mailtrap::Webhook id=1, ...>

# Update webhook
webhooks_api.update(
  webhook.id,
  active: false,
  event_types: %w[delivery bounce unsubscribe]
)
# => #<struct Mailtrap::Webhook id=1, active=false, ...>

# Delete webhook
webhooks_api.delete(webhook.id)
# => #<struct Mailtrap::Webhook id=1, ...>
