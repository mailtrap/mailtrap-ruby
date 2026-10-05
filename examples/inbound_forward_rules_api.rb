require 'mailtrap'

client = Mailtrap::Client.new(api_key: 'your-api-key')
forward_rules = Mailtrap::InboundForwardRulesAPI.new(client)
inbox_id = 42

# Create a forward rule
rule = forward_rules.create(
  inbox_id,
  name: 'Copy billing mail to finance',
  conditions: [{ match_type: 'sender', operator: 'ends_with', value: '@billing.example.com' }],
  destinations: [{ email: 'finance@example.com' }]
)
# => #<struct Mailtrap::InboundForwardRule id=7, name="Copy billing mail to finance", conditions=[...], ...>

# List forward rules
forward_rules.list(inbox_id)
# => [#<struct Mailtrap::InboundForwardRule id=7, ...>]

# Get a forward rule
forward_rules.get(inbox_id, rule.id)
# => #<struct Mailtrap::InboundForwardRule id=7, ...>

# Update a forward rule
forward_rules.update(
  inbox_id,
  rule.id,
  destinations: [{ email: 'finance@example.com' }, { email: 'accounting@example.com' }]
)
# => #<struct Mailtrap::InboundForwardRule id=7, destinations=[...]>

# Delete a forward rule
forward_rules.delete(inbox_id, rule.id)
# => nil
