require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
domains = Mailtrap::DomainsAPI.new(account_id, client)

# Create new domain
domain = domains.create(domain_name: 'example.com')
# => #<struct Mailtrap::Domain id=1, domain_name="example.com">

# Get all domains
domains.list
# => [#<struct Mailtrap::Domain id=1, domain_name="example.com">]

# Get domain
domain = domains.get(domain.id)
# => #<struct Mailtrap::Domain id=1, domain_name="example.com">

# Update domain configuration
domains.update(
  domain.id,
  open_tracking_enabled: true,
  click_tracking_enabled: true,
  tracking_opt_out_enabled: true,
  auto_unsubscribe_link_enabled: false,
  inbound_enabled: false
)
# => #<struct Mailtrap::Domain id=1, domain_name="example.com", ...>

# Send setup email
domains.send_setup_instructions(domain.id, email: 'jonathan@mail.com')
# => nil

# Delete domain
domains.delete(domain.id)
# => nil
