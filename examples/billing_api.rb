require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
billing_api = Mailtrap::BillingAPI.new(account_id, client)

# Get billing information for the account
billing_api.get
# => #<Mailtrap::Billing billing: { cycle_start: '2026-02-06T12:59:54.000Z', ... }, ...>
