require 'mailtrap'
require 'date'
require 'time'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
stats = Mailtrap::StatsAPI.new(account_id, client)

# Get aggregated sending stats
stats.get(start_date: '2026-01-01', end_date: '2026-01-31')
# => #<struct Mailtrap::SendingStats
#      delivery_count=150, delivery_rate=0.95,
#      bounce_count=8, bounce_rate=0.05,
#      open_count=120, open_rate=0.8,
#      click_count=60, click_rate=0.5,
#      spam_count=2, spam_rate=0.013>

# Get stats grouped by domain
stats.by_domain(start_date: '2026-01-01', end_date: '2026-01-31')
# => [#<struct Mailtrap::SendingStatGroup
#      name=:sending_domain_id, value=1,
#      stats=#<struct Mailtrap::SendingStats delivery_count=100, ...>>, ...]

# Get stats grouped by category
stats.by_category(start_date: Date.today.prev_day(30), end_date: Date.today)
# => [#<struct Mailtrap::SendingStatGroup
#      name=:category, value="Transactional",
#      stats=#<struct Mailtrap::SendingStats delivery_count=100, ...>>, ...]

# Get stats grouped by email service provider
stats.by_email_service_provider(start_date: Time.new(2026, 1, 1), end_date: Time.new(2026, 1, 31))
# => [#<struct Mailtrap::SendingStatGroup
#      name=:email_service_provider, value="Gmail",
#      stats=#<struct Mailtrap::SendingStats delivery_count=80, ...>>, ...]

# Get stats grouped by date
stats.by_date(start_date: '2026-01-01', end_date: '2026-01-31')
# => [#<struct Mailtrap::SendingStatGroup
#      name=:date, value="2026-01-01",
#      stats=#<struct Mailtrap::SendingStats delivery_count=5, ...>>, ...]

# With optional filters
stats.get(
  start_date: '2026-01-01',
  end_date: '2026-01-31',
  sending_domain_ids: [1, 2],
  categories: ['Transactional']
)
