# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for SandboxAttachment
  # @see https://docs.mailtrap.io/developers/email-sandbox/email-sandbox-api/attachments
  # @attr_reader id [Integer] The project ID
  # @attr_reader message_id [Integer] The message ID
  # @attr_reader filename [String] The attachment filename
  # @attr_reader attachment_type [String] The attachment type
  # @attr_reader content_type [String] The attachment content type
  # @attr_reader content_id [String] The attachment content ID
  # @attr_reader transfer_encoding [String] The attachment transfer encoding
  # @attr_reader attachment_size [Integer] The attachment size in bytes
  # @attr_reader created_at [String] The attachment creation timestamp
  # @attr_reader updated_at [String] The attachment update timestamp
  # @attr_reader attachment_human_size [String] The attachment size in human-readable format
  # @attr_reader download_path [String] The attachment download path
  #
  SandboxAttachment = Struct.new(
    :id,
    :message_id,
    :filename,
    :attachment_type,
    :content_type,
    :content_id,
    :transfer_encoding,
    :attachment_size,
    :created_at,
    :updated_at,
    :attachment_human_size,
    :download_path,
    keyword_init: true
  )
end
