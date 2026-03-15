require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
email_logs = Mailtrap::EmailLogsAPI.new(account_id, client)

# Set your API credentials as environment variables
# export MAILTRAP_API_KEY='your-api-key'
# export MAILTRAP_ACCOUNT_ID=your-account-id
#
# email_logs = Mailtrap::EmailLogsAPI.new

# List email logs (first page)
response = email_logs.list
# => #<struct Mailtrap::EmailLogsListResponse
#      messages=[#<struct Mailtrap::EmailLogMessage message_id="...", status="delivered", ...>, ...],
#      total_count=150,
#      next_page_cursor="b2c3d4e5-f6a7-8901-bcde-f12345678901">

response.messages.each { |m| puts "#{m.message_id} #{m.status} #{m.subject}" }

# List with filters (date range: last 2 days, recipient, status)
sent_after = (Time.now.utc - (2 * 24 * 3600)).iso8601
sent_before = Time.now.utc.iso8601
response = email_logs.list(
  filters: {
    sent_after:,
    sent_before:,
    subject: { operator: 'not_empty' },
    to: { operator: 'ci_equal', value: 'recipient@example.com' },
    category: { operator: 'equal', value: ['Welcome Email', 'Transactional Email'] }
  }
)

# List next page using cursor from previous response
response = email_logs.list(search_after: response.next_page_cursor) if response.next_page_cursor

# Get a single message by ID (includes events and raw_message_url)
message_id = response.messages.first&.message_id
if message_id
  message = email_logs.get(message_id)
  # => #<struct Mailtrap::EmailLogMessage
  #      message_id="a1b2c3d4-...", status="delivered", subject="Welcome", ...,
  #      raw_message_url="https://storage.../signed/eml/...",
  #      events=[#<struct Mailtrap::EmailLogEvent event_type="delivery", ...>, ...]>

  puts message.raw_message_url
  message.events&.each { |e| puts "#{e.event_type} at #{e.created_at}" }
end
