require 'mailtrap'

organization_id = 4567
client = Mailtrap::Client.new(api_key: 'your-api-key')
sub_accounts = Mailtrap::SubAccountsAPI.new(organization_id, client)

# List sub accounts under the organization
sub_accounts.list
# => [#<struct Mailtrap::SubAccount id=12345, name="Development Team Account">, ...]

# Create a new sub account
sub_accounts.create(name: 'New Team Account')
# => #<struct Mailtrap::SubAccount id=12347, name="New Team Account">
