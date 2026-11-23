require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
contact_lists = Mailtrap::ContactListsAPI.new(account_id, client)
contacts = Mailtrap::ContactsAPI.new(account_id, client)
contact_fields = Mailtrap::ContactFieldsAPI.new(account_id, client)
contact_imports = Mailtrap::ContactImportsAPI.new(account_id, client)

# Set your API credentials as environment variables
# export MAILTRAP_API_KEY='your-api-key'
# export MAILTRAP_ACCOUNT_ID=your-account-id

# contact_lists = Mailtrap::ContactListsAPI.new
# contacts = Mailtrap::ContactsAPI.new
# contact_fields = Mailtrap::ContactFieldsAPI.new
# contact_imports = Mailtrap::ContactImportsAPI.new

# Create new contact list
list = contact_lists.create(name: 'Test List')
# => #<struct Mailtrap::ContactList id=1, name="Test List">

# Get all contact lists
contact_lists.list
# => [#<struct Mailtrap::ContactList id=1, name="Test List">]

# Filter contact lists by name (case-insensitive prefix match)
contact_lists.list(search: 'news')
# => [#<struct Mailtrap::ContactList id=2, name="Newsletter">]

# Update contact list
contact_lists.update(list.id, name: 'Test List Updated')
# => #<struct Mailtrap::ContactList id=1, name="Test List Updated">

# Get contact list
list = contact_lists.get(list.id)
# => #<struct Mailtrap::ContactList id=1, name="Test List Updated">

# Delete contact list
contact_lists.delete(list.id)

# Create new contact field
field = contact_fields.create(name: 'Nickname', data_type: 'text', merge_tag: 'nickname')
# => #<struct Mailtrap::ContactField id=1, name="Nickname", data_type="text", merge_tag="nickname">

# Get all contact fields
contact_fields.list
# => [#<struct Mailtrap::ContactField id=1, name="Nickname", data_type="text", merge_tag="nickname">]

# Update contact field
contact_fields.update(field.id, name: 'Nickname 2', merge_tag: 'nickname')
# => #<struct Mailtrap::ContactField id=1, name="Nickname 2", data_type="text", merge_tag="nickname">

# Get contact field
field = contact_fields.get(field.id)
# => #<struct Mailtrap::ContactField id=1, name="Nickname 2", data_type="text", merge_tag="nickname">

# Create new contact with all possible fields
contact = contacts.create(
  email: 'test@example.com',
  fields: { field.merge_tag => 'John Doe' },
  list_ids: [list.id]
)
# => #<struct Mailtrap::Contact
#      id=1,
#      email="test@example.com",
#      fields={ "nickname" => "John Doe" },
#      list_ids=[1],
#      status="subscribed",
#      created_at=1721212345,
#      updated_at=1721212345>
contact.newly_created? # => true

# Get contact
contact = contacts.get(contact.id)
# => #<struct Mailtrap::Contact
#      id=1,
#      email="test@example.com",
#      fields={ "nickname" => "John Doe" },
#      list_ids=[1],
#      status="subscribed",
#      created_at=1721212345,
#      updated_at=1721212345>

# Update contact using id
updated_contact = contacts.upsert(
  contact.id,
  email: 'test2@example.com',
  fields: { field.merge_tag => 'Jane Doe' }
)
# => #<struct Mailtrap::Contact
#      id=1,
#      email="test2@example.com",
#      fields={ "nickname" => "Jane Doe" },
#      list_ids=[1],
#      status="subscribed",
#      created_at=1721212345,
#      updated_at=1721212350>
updated_contact.newly_created? # => false

# Update contact using email
contacts.upsert(
  updated_contact.email,
  email: 'test3@example.com',
  fields: { field.merge_tag => 'Jane Doe' }
)
# => #<struct Mailtrap::Contact
#      id=1,
#      email="test3@example.com",
#      fields={ "nickname" => "Jane Doe" },
#      list_ids=[1],
#      status="subscribed",
#      created_at=1721212345,
#      updated_at=1721212355>
updated_contact.newly_created? # => false

# Set the contact's subscription topic preferences, one per topic and sending domain
# (see subscription_topics_api.rb); preferences left out keep their status.
# A topic with a domain_id applies to that domain only; one without applies to every domain.
# Without subscription topics, listing them raises Mailtrap::RejectionError, Contact#subscription_topics
# is nil and setting them raises Mailtrap::Error ("are not available for this account").
begin
  topic = Mailtrap::SubscriptionTopicsAPI.new(client).list.data.first
  topic_domain_id = topic && (topic.domain_id || Mailtrap::DomainsAPI.new(account_id, client).list.first&.id)
  if topic_domain_id
    topic_contact = contacts.upsert(
      contact.id,
      subscription_topics: [{ subscription_topic_id: topic.id, domain_id: topic_domain_id, status: 'unsubscribed' }]
    )
    topic_contact.subscription_topics
    # => [{ subscription_topic_id: 12, domain_id: 4321, status: "unsubscribed" }, ...]
  end
rescue Mailtrap::Error => e
  puts "Subscription topic preferences are not available: #{e.message}"
end

# Remove contact from lists
contacts.remove_from_lists(contact.id, [list.id])
# => #<struct Mailtrap::Contact
#      id=1,
#      email="test3@example.com",
#      fields={ "nickname" => "Jane Doe" },
#      list_ids=[],
#      status="subscribed",
#      created_at=1721212345,
#      updated_at=1721212360>

# Add contact to lists
contacts.add_to_lists(contact.id, [list.id])
# => #<struct Mailtrap::Contact
#      id=1,
#      email="test3@example.com",
#      fields={ "nickname" => "Jane Doe" },
#      list_ids=[1],
#      status="subscribed",
#      created_at=1721212345,
#      updated_at=1721212365>

# Delete contact
contacts.delete(contact.id)

# Delete contact field
contact_fields.delete(field.id)

# Create a new contact import using ContactsImportRequest builder
import_request = Mailtrap::ContactsImportRequest.new.tap do |req|
  req.upsert(email: 'john.doe@example.com', fields: { first_name: 'John' })
     .add_to_lists(email: 'john.doe@example.com', list_ids: [1])
     .remove_from_lists(email: 'jane.smith@example.com', list_ids: [2])

  req.upsert(email: 'jane.smith@example.com', fields: { first_name: 'Jane' })
     .add_to_lists(email: 'jane.smith@example.com', list_ids: [1])
     .remove_from_lists(email: 'jane.smith@example.com', list_ids: [2])
end

# Execute the import
contact_import = contact_imports.create(import_request)
# => #<struct Mailtrap::ContactImport
#      id=1,
#      status="created",
#      created_contacts_count=nil,
#      updated_contacts_count=nil,
#      contacts_over_limit_count=nil>

# Wait for the import to complete (if needed)

# Get the import status
contact_imports.get(contact_import.id)
# => #<struct Mailtrap::ContactImport
#      id=1,
#      status="finished",
#      created_contacts_count=2,
#      updated_contacts_count=0,
#      contacts_over_limit_count=0>

# Import using plain hash
contact_imports.create(
  [
    { email: 'john@example.com', fields: { first_name: 'John' }, list_ids_included: [1], list_ids_excluded: [2] },
    { email: 'jane@example.com', fields: { first_name: 'Jane' }, list_ids_included: [1], list_ids_excluded: [2] }
  ]
)

# Import subscription topic preferences, as for contacts.upsert above
# (on an account without subscription topics, the import fails)
if topic_domain_id
  topics_import = Mailtrap::ContactsImportRequest.new.tap do |req|
    req.upsert(email: 'john.doe@example.com')
       .update_subscription_topics(
         email: 'john.doe@example.com',
         subscription_topics: [{ subscription_topic_id: topic.id, domain_id: topic_domain_id, status: 'subscribed' }]
       )
  end
  begin
    contact_imports.create(topics_import)
  rescue Mailtrap::Error => e
    puts "Subscription topic preferences are not available: #{e.message}"
  end
end
