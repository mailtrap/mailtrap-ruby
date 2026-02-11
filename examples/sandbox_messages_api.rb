require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
inbox_id = 12
sandbox_messages = Mailtrap::SandboxMessagesAPI.new(inbox_id, account_id, client)

# List all sandbox messages in the inbox (optional: search, page, last_id)
sandbox_messages.list
# => [#<struct Mailtrap::SandboxMessage id=1, subject="Welcome", ...>]

# List with search (matches subject, to_email, to_name)
sandbox_messages.list(search: 'welcome')
sandbox_messages.list(page: 2)
sandbox_messages.list(last_id: 100)

# Get a specific message
message_id = 123
sandbox_messages.get(message_id)
# => #<struct Mailtrap::SandboxMessage id=123, subject="...", is_read=false, ...>

# Update message (e.g. mark as read)
sandbox_messages.update(message_id, is_read: true)
# => #<struct Mailtrap::SandboxMessage id=123, is_read=true, ...>

# Get message bodies and metadata
sandbox_messages.text_body(message_id)      # => plain text body
sandbox_messages.html_body(message_id)      # => HTML body
sandbox_messages.html_source(message_id)    # => HTML source
sandbox_messages.raw_body(message_id)       # => raw email body
sandbox_messages.eml_body(message_id)       # => EML format
sandbox_messages.mail_headers(message_id)   # => mail headers hash

# Get message analysis
sandbox_messages.spam_score(message_id)     # => spam report hash
sandbox_messages.html_analysis(message_id)  # => HTML analysis hash

# Forward message to an email address
sandbox_messages.forward_message(message_id: message_id, email: 'recipient@example.com')
# => forwarded message confirmation

# Delete a sandbox message
sandbox_messages.delete(message_id)
# => #<struct Mailtrap::SandboxMessage id=123, ...> (deleted)
