require 'mailtrap'

client = Mailtrap::Client.new(api_key: 'your-api-key')
tracking_opt_outs = Mailtrap::TrackingOptOutsAPI.new(client)

# Set your API credentials as an environment variable
# export MAILTRAP_API_KEY='your-api-key'
#
# tracking_opt_outs = Mailtrap::TrackingOptOutsAPI.new

# Get tracking opt-outs
response = tracking_opt_outs.list
# =>
#  #<struct Mailtrap::TrackingOptOutsListResponse
#    data=[
#      #<struct Mailtrap::TrackingOptOut
#        id="64d71bf3-1276-417b-86e1-8e66f138acfe",
#        email="tracked@example.com",
#        created_at="2025-01-15T10:30:00Z",
#        domain_name="example.com">
#    ],
#    last_id=nil>

response.data.each { |opt_out| puts opt_out.email }

# Filter by email and creation time
tracking_opt_outs.list(
  email: 'tracked@example.com',
  start_time: '2025-01-01T00:00:00Z',
  end_time: '2025-12-31T23:59:59Z'
)

# Page through large lists — pass the previous response's `last_id` until it is nil
page = tracking_opt_outs.list
while page.last_id
  page = tracking_opt_outs.list(last_id: page.last_id)
  puts page.data.size
end

# Opt an email out of open and click tracking for a sending domain
opt_out = tracking_opt_outs.create(email: 'tracked@example.com', domain_id: 12_345)
# => #<struct Mailtrap::TrackingOptOut id="64d71bf3-1276-417b-86e1-8e66f138acfe", ...>

# Remove an email from the tracking opt-out list. Returns the deleted record.
tracking_opt_outs.delete(opt_out.id)
# => #<struct Mailtrap::TrackingOptOut id="64d71bf3-1276-417b-86e1-8e66f138acfe", ...>
