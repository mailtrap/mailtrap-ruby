require 'mailtrap'

client = Mailtrap::Client.new(api_key: 'your-api-key')
threads = Mailtrap::InboundThreadsAPI.new(client)
inbox_id = 42

# List threads in an inbox (cursor-paginated)
page = threads.list(inbox_id)
# => #<struct Mailtrap::InboundThreadsListResponse data=[...], total_count=1, last_id=nil>

# Fetch the next page with the returned cursor
threads.list(inbox_id, last_id: page.last_id) if page.last_id

# Get a single thread with its messages embedded (oldest first)
threads.get(inbox_id, page.data.first.id)
# => #<struct Mailtrap::InboundThread id="1700000000000124", messages=[...]>

# Delete a thread
threads.delete(inbox_id, page.data.first.id)
# => nil
