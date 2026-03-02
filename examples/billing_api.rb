require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
billing = Mailtrap::BillingAPI.new(account_id, client)

# Get current billing cycle usage
billing.usage
# => #<struct Mailtrap::BillingUsage
#      billing={cycle_start: "2026-02-06T12:59:54.000Z", cycle_end: "2026-03-06T12:59:54.000Z"},
#      testing={
#        plan: {name: "Team"},
#        usage: {
#          sent_messages_count: {current: 0, limit: 5000},
#          forwarded_messages_count: {current: 0, limit: 500}
#        }
#      },
#      sending={
#        plan: {name: "Basic 10K"},
#        usage: {
#          sent_messages_count: {current: 0, limit: 10000}
#        }
#      }>
