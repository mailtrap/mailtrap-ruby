require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
sending_domains = Mailtrap::InboxesAPI.new(account_id, client)

# Create new Sending Domain
sending_domain = sending_domains.create(domain_name: 'example.com')
# => #<struct Mailtrap::SendingDomain id=1, domain_name="example.com">

# Get all Sending Domains
sending_domains.list
# => [#<struct Mailtrap::SendingDomain id=1, domain_name="example.com">]

# Update Sending Domain
sending_domains.update(sending_domain.id, domain_name: 'proper.com')
# => #<struct Mailtrap::SendingDomain id=1, domain_name="proper.com">

# Get sending domain
sending_domain = sending_domains.get(sending_domain.id)
# => #<struct Mailtrap::SendingDomain id=1, domain_name="proper.com">

# Send setup email
sending_domains.clean(sending_domain.id, 'jonathan@mail.com')
# => nil

# Delete sending domain
sending_domains.delete(sending_domain.id)
# => nil
