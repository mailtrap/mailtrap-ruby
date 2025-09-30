require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
suppressions = Mailtrap::SuppressionsAPI.new(account_id, client)

# Set your API credentials as environment variables
# export MAILTRAP_API_KEY='your-api-key'
# export MAILTRAP_ACCOUNT_ID=your-account-id
#
# suppressions = Mailtrap::SuppressionsAPI.new

# Get all suppressions
suppressions.list
# =>
#  [
#    #<struct Mailtrap::Suppression
#      id="64d71bf3-1276-417b-86e1-8e66f138acfe",
#      type="unsubscription",
#      created_at="2024-12-26T09:40:44.161Z",
#      email="recipient@example.com",
#      sending_stream="transactional",
#      domain_name="example.com",
#      message_bounce_category="",
#      message_category="Welcome email",
#      message_client_ip="123.123.123.123",
#      message_created_at="2024-12-26T07:10:00.889Z",
#      message_esp_response="",
#      message_esp_server_type="",
#      message_outgoing_ip="1.1.1.1",
#      message_recipient_mx_name="Other Providers",
#      message_sender_email="hello@sender.com",
#      message_subject="Welcome!">
#  ]

# Get suppressions for the email
list = suppressions.list(email: 'recipient@example.com')

# Delete a suppression
suppressions.delete(list.first.id)
