require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
permissions = Mailtrap::PermissionsAPI.new(account_id, client)

# Get the recursive tree of resources the current token can access
permissions.resources
# => [
#   #<struct Mailtrap::PermissionResource id=4001, name="My First Project", type="project",
#     access_level=1, resources=[
#       #<struct Mailtrap::PermissionResource id=3816, name="My First Inbox", type="inbox",
#         access_level=100, resources=[]>
#     ]>
# ]

# Bulk-update user/token permissions on an account access. Combine create/update with destroy:
permissions.bulk_update(
  5142, # account_access_id
  [
    { resource_id: '3281', resource_type: 'account', access_level: 'viewer' },
    { resource_id: '3809', resource_type: 'inbox', _destroy: true }
  ]
)
# => { message: "Permissions have been updated!" }
