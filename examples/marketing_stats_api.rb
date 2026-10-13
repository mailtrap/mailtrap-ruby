require 'mailtrap'
require 'date'

client = Mailtrap::Client.new(api_key: 'your-api-key')
marketing_stats = Mailtrap::MarketingStatsAPI.new(client)

today = Date.today

# Get aggregated Email Marketing stats (campaigns and automations) for the last 30 days
marketing_stats.get(start_date: today - 30, end_date: today)
# => #<struct Mailtrap::MarketingStats
#      delivery_count=1200, delivery_rate=0.96,
#      bounce_count=50, bounce_rate=0.04,
#      open_count=600, open_rate=0.5,
#      click_count=240, click_rate=0.2,
#      spam_count=3, spam_rate=0.0025,
#      unsubscription_count=12, unsubscription_rate=0.01,
#      sent_count=1250>

# Narrow to campaigns only (or automations only), for some sending domains and email service providers
marketing_stats.get(
  start_date: today - 30,
  end_date: today,
  sending_domain_ids: [3938, 3939],
  sources: ['campaigns'],
  email_service_providers: %w[Google Yahoo]
)
# => #<struct Mailtrap::MarketingStats delivery_count=900, delivery_rate=0.97, ...>
