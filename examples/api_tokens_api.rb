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
# `expires_at` is optional – omit it for the server default (a 1-year default is being
# rolled out), pass an ISO 8601 date-time for an explicit expiry, or pass explicit nil
# for a token that never expires.
api_tokens.create(
  name: 'My API Token',
  expires_at: '2027-06-01T00:00:00Z',
  resources: [
    { resource_type: 'account', resource_id: account_id, access_level: 100 }
  ]
)
# => #<struct Mailtrap::ApiToken id=12345, ..., expires_at="2027-06-01T00:00:00Z", token="a1b2c3d4e5f6g7h8">

# Create a token that never expires
api_tokens.create(
  name: 'My API Token',
  expires_at: nil,
  resources: [
    { resource_type: 'account', resource_id: account_id, access_level: 100 }
  ]
)
# => #<struct Mailtrap::ApiToken id=12345, name="My API Token", ..., expires_at=nil, token="a1b2c3d4e5f6g7h8">

# Reset a token — expires the old value (short grace period) and returns a new value once.
# `expires_at` is optional and works the same as on create.
api_tokens.reset(12_345)
# => #<struct Mailtrap::ApiToken id=12345, ..., token="new-secret-value">

# Reset a token with an explicit expiry for the new token
api_tokens.reset(12_345, expires_at: '2027-06-01T00:00:00Z')
# => #<struct Mailtrap::ApiToken id=12345, ..., expires_at="2027-06-01T00:00:00Z", token="new-secret-value">

# Permanently delete a token
api_tokens.delete(12_345)
# => nil
