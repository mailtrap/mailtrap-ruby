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

# Create an `audit_log` webhook
webhooks_api.create(
  url: 'https://example.com/mailtrap/audit-log',
  webhook_type: 'audit_log'
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
