require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
api_tokens = Mailtrap::ApiTokensAPI.new(account_id, client)

# List API tokens
api_tokens.list
# => [#<struct Mailtrap::ApiToken id=12345, name="My API Token", last_4_digits="x7k9", ..., token=nil>, ...]
