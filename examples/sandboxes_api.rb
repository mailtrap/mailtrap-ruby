require 'mailtrap'

account_id = 3229
client = Mailtrap::Client.new(api_key: 'your-api-key')
sandboxes = Mailtrap::SandboxesAPI.new(account_id, client)

# Create new sandbox
sandbox = sandboxes.create(name: 'Test Sandbox', project_id: 123_456)
# => #<struct Mailtrap::Sandbox id=1, name="Test Sandbox">

# Get all sandboxes
sandboxes.list
# => [#<struct Mailtrap::Sandbox id=1, name="Test Sandbox">]

# Update sandbox
sandboxes.update(sandbox.id, name: 'Test Sandbox Updated')
# => #<struct Mailtrap::Sandbox id=1, name="Test Sandbox Updated">

# Get sandbox
sandbox = sandboxes.get(sandbox.id)
# => #<struct Mailtrap::Sandbox id=1, name="Test Sandbox Updated">

# Delete all messages (emails) from the sandbox
sandboxes.clean(sandbox.id)

# Mark all messages in the sandbox as read
sandboxes.mark_as_read(sandbox.id)

# Reset SMTP credentials of the sandbox
sandboxes.reset_credentials(sandbox.id)

# Turn the email address of the sandbox on/off
sandboxes.toggle_email_username(sandbox.id)

# Reset username of email address per sandbox
sandboxes.reset_email_username(sandbox.id)

# Delete sandbox
sandboxes.delete(sandbox.id)
