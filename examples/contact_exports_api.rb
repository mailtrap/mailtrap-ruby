require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
contact_exports = Mailtrap::ContactExportsAPI.new(account_id, client)

# Create a contact export filtered by list IDs
contact_exports.create(
  filters: [
    { name: 'list_id', operator: 'equal', value: [1, 2] }
  ]
)
# => #<struct Mailtrap::ContactExport id=1, status="started", created_at="...", updated_at="...", url=nil>

# Create a contact export filtered by subscription status
contact_exports.create(
  filters: [
    { name: 'subscription_status', operator: 'equal', value: 'subscribed' }
  ]
)
# => #<struct Mailtrap::ContactExport id=2, status="started", ..., url=nil>

# Get a contact export by ID — once status is "finished", `url` is the file location
contact_exports.get(1)
# => #<struct Mailtrap::ContactExport id=1, status="finished", ..., url="https://...">

