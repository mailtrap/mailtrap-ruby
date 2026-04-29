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
