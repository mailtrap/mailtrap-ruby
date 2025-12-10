require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
projects_api = Mailtrap::ProjectsAPI.new(account_id, client)

# Set your API credentials as environment variables
# export MAILTRAP_API_KEY='your-api-key'
# export MAILTRAP_ACCOUNT_ID=your-account-id
#
# projects_api = Mailtrap::ProjectsAPI.new

# Get all projects
projects_api.list

# Create a new project
project = projects_api.create(
  name: 'Example Project'
)

# Get a project
project = projects_api.get(project.id)

# Update a project
project = projects_api.update(project.id, name: 'New Project name')

# Delete a project
projects_api.delete(project.id)
