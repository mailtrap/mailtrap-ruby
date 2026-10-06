require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
templates = Mailtrap::TemplatesAPI.new(account_id, client)

# Set your API credentials as environment variables
# export MAILTRAP_API_KEY='your-api-key'
# export MAILTRAP_ACCOUNT_ID=your-account-id
#
# templates = Mailtrap::TemplatesAPI.new

# Create a new Template
template = templates.create(
  name: 'Welcome Email',
  subject: 'Welcome to Acme!',
  category: 'Welcome',
  body_html: '<div>Welcome, {{name}}!</div>',
  body_text: 'Welcome, {{name}}!'
)
# => #<struct Mailtrap::Template id=26730, name="Welcome Email", subject="Welcome to Acme!", ...>

# Get all Templates (paginated)
list = templates.list(per_page: 50, token: 1)
# => #<struct Mailtrap::TemplatesListResponse data=[#<struct Mailtrap::Template ...>], pagination={...}>
list.data
# => [#<struct Mailtrap::Template id=26730, name="Welcome Email", ...>]
list.pagination
# => {:token=>1, :prev_token=>nil, :next_token=>2, ...}

# Follow the pagination to the next page
templates.list(per_page: 50, token: list.pagination[:next_token]) if list.pagination[:next_token]
# => #<struct Mailtrap::TemplatesListResponse data=[...], pagination={...}>

# Get a single Template
template = templates.get(template.id)
# => #<struct Mailtrap::Template id=26730, name="Welcome Email", ...>

# Update a Template (partial)
template = templates.update(template.id, subject: 'Welcome aboard!')
# => #<struct Mailtrap::Template id=26730, subject="Welcome aboard!", ...>

# Delete a Template (returns nil)
templates.delete(template.id)
# => nil
