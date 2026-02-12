require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
account_accesses = Mailtrap::AccountAccessesAPI.new(account_id, client)

# List all account accesses
account_accesses.list
# => [#<struct Mailtrap::AccountAccess id=1, specifier_type="user", specifier={...}, ...>]

# List with optional filters: domain_ids, inbox_ids, project_ids
account_accesses.list(domain_ids: [1, 2])
account_accesses.list(inbox_ids: [12, 34])
account_accesses.list(project_ids: [100, 200])

# Combine multiple filters
account_accesses.list(domain_ids: [1], inbox_ids: [12], project_ids: [100])

# Delete an account access
account_access_id = 123
account_accesses.delete(account_access_id)
# => #<struct Mailtrap::AccountAccess id=123, ...> (deleted)
