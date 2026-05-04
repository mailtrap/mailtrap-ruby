require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
contact_events = Mailtrap::ContactEventsAPI.new(account_id, client)

# Submit a custom event for a contact (identifier can be UUID or email)
contact_events.create(
  'john.smith@example.com',
  name: 'UserLogin',
  params: {
    user_id: 101,
    user_name: 'John Smith',
    is_active: true,
    last_seen: nil
  }
)
# => #<struct Mailtrap::ContactEvent contact_id="018dd5e3-f6d2-7c00-8f9b-e5c3f2d8a132",
#                                   contact_email="john.smith@example.com",
#                                   name="UserLogin",
#                                   params={"user_id"=>101, ...}>
