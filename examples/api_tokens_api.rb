require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
api_tokens = Mailtrap::ApiTokensAPI.new(account_id, client)

# List API tokens
api_tokens.list
# => [#<struct Mailtrap::ApiToken id=12345, name="My API Token", last_4_digits="x7k9", ..., token=nil>, ...]

# Get a single API token (the `token` field is nil — the full value is only returned by create/reset)
api_tokens.get(12_345)
# => #<struct Mailtrap::ApiToken id=12345, name="My API Token", ..., token=nil>

# Create a new API token. The full `token` value is returned ONLY once — store it securely.
api_tokens.create(
  name: 'My API Token',
  resources: [
    { resource_type: 'account', resource_id: account_id, access_level: 100 }
  ]
)
# => #<struct Mailtrap::ApiToken id=12345, name="My API Token", ..., token="a1b2c3d4e5f6g7h8">
