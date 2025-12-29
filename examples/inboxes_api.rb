require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
inboxes = Mailtrap::InboxesAPI.new(account_id, client)

# Create new Inbox
list = inboxes.create(name: 'Test Inbox', project_id: 123_456)
# => #<struct Mailtrap::Inbox id=1, name="Test Inbox">

# Get all Inboxes
inboxes.list
# => [#<struct Mailtrap::Inbox id=1, name="Test Inbox">]

# Update contact list
inboxes.update(list.id, name: 'Test List Updated')
# => #<struct Mailtrap::Inbox id=1, name="Test Inbox Updated">

# Get contact list
inbox = inboxes.get(list.id)
# => #<struct Mailtrap::Inbox id=1, name="Test Inbox Updated">

# Delete all messages (emails) from Inbox
inboxes.clean(inbox.id)

# Mark all messages in the inbox as read
inboxes.mark_as_read(inbox.id)

# Reset SMTP credentials of the inbox
inboxes.reset_credentials(inbox.id)

# Delete contact list
inboxes.delete(inbox.id)
