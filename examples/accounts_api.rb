require 'mailtrap'

client = Mailtrap::Client.new(api_key: 'your-api-key')
account_id = 3229
accounts = Mailtrap::AccountsAPI.new(account_id, client)

# Set your API credentials as environment variables
# export MAILTRAP_API_KEY='your-api-key'
# export MAILTRAP_ACCOUNT_ID=your-account-id

# accounts = Mailtrap::AccountsAPI.new

# Get all accounts
accounts.list
# => [#<struct Mailtrap::Account id=123456, name="My Account", access_levels=[1000]>]
