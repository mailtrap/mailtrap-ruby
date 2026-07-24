require 'mailtrap'

client = Mailtrap::Client.new(api_key: 'your-api-key')
folders = Mailtrap::InboundFoldersAPI.new(client)

# Create a folder
folder = folders.create(name: 'Support')
# => #<struct Mailtrap::InboundFolder id=1, name="Support">

# List all folders
folders.list
# => [#<struct Mailtrap::InboundFolder id=1, name="Support">]

# Get a folder
folders.get(folder.id)
# => #<struct Mailtrap::InboundFolder id=1, name="Support">

# Update a folder
folders.update(folder.id, name: 'Customer Success')
# => #<struct Mailtrap::InboundFolder id=1, name="Customer Success">

# Delete a folder (and all of its inboxes)
folders.delete(folder.id)
# => nil
