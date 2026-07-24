require 'mailtrap'

client = Mailtrap::Client.new(api_key: 'your-api-key')
inboxes = Mailtrap::InboundInboxesAPI.new(client)
folder_id = 1

# Create an inbox. Omit domain_id for a Mailtrap-hosted inbox; pass it for a custom-domain inbox.
inbox = inboxes.create(folder_id, name: 'Tickets')
# => #<struct Mailtrap::InboundInbox id=42, name="Tickets", address="...@inbound-mailtrap.io", domain_id=892>

# List inboxes in a folder
inboxes.list(folder_id)
# => [#<struct Mailtrap::InboundInbox id=42, ...>]

# Get an inbox
inboxes.get(folder_id, inbox.id)
# => #<struct Mailtrap::InboundInbox id=42, ...>

# Update an inbox
inboxes.update(folder_id, inbox.id, name: 'Tickets (renamed)')
# => #<struct Mailtrap::InboundInbox id=42, name="Tickets (renamed)", ...>

# Delete an inbox
inboxes.delete(folder_id, inbox.id)
# => nil
