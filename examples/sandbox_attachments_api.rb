require 'mailtrap'

account_id = 3229
inbox_id = 12
message_id = 123
client = Mailtrap::Client.new(api_key: 'your-api-key')
sandbox_attachments = Mailtrap::SandboxAttachmentsAPI.new(account_id, inbox_id, message_id, client)

# List all attachments for a sandbox message (up to 30)
sandbox_attachments.list
# => [#<struct Mailtrap::SandboxAttachment id=1, filename="document.pdf", ...>, ...]

# Get a specific attachment by ID
attachment_id = 456
sandbox_attachments.get(attachment_id)
# => #<struct Mailtrap::SandboxAttachment id=456, message_id=123, filename="document.pdf",
#     attachment_type="attachment", content_type="application/pdf", content_id=nil,
#     transfer_encoding="base64", attachment_size=1024, created_at="...", updated_at="...",
#     attachment_human_size="1 KB", download_path="/path/to/download", ...>
