require 'mailtrap'

organization_id = 4567
client = Mailtrap::Client.new(api_key: 'your-api-key')
sub_accounts = Mailtrap::SubAccountsAPI.new(organization_id, client)

# Create a new sub account
sub_accounts.create(name: 'New Team Account')
# => #<struct Mailtrap::SubAccount id=12347, name="New Team Account">
