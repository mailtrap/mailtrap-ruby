require 'mailtrap'

client = Mailtrap::Client.new(api_key: 'your-api-key')
messages = Mailtrap::InboundMessagesAPI.new(client)
inbox_id = 42

# List messages in an inbox (cursor-paginated)
page = messages.list(inbox_id)
# => #<struct Mailtrap::InboundMessagesListResponse data=[...], total_count=1, last_id=nil>

# Fetch the next page with the returned cursor
messages.list(inbox_id, last_id: page.last_id) if page.last_id

# Get a single message with its body and attachment download URLs
message = messages.get(inbox_id, page.data.first.id)
# => #<struct Mailtrap::InboundMessage id="1700000000000123", ...>

# Reply to the original sender
messages.reply(inbox_id, message.id, text: 'Thanks for reaching out.')
# => #<struct Mailtrap::InboundSendResult message_ids=["1a2b3c4d-..."]>

# Reply to everyone on the original message
messages.reply_all(inbox_id, message.id, text: 'Looping everyone in.')
# => #<struct Mailtrap::InboundSendResult message_ids=["1a2b3c4d-..."]>

# Forward to new recipients (at least one `to` is required)
messages.forward(inbox_id, message.id, to: [{ email: 'colleague@example.com' }], text: 'Please take a look.')
# => #<struct Mailtrap::InboundSendResult message_ids=["1a2b3c4d-..."]>

# Delete a message
messages.delete(inbox_id, message.id)
# => nil
