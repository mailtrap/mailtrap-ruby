# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for an inbound message attachment
  # @see https://docs.mailtrap.io/developers/inbound
  # @attr_reader attachment_id [String] The attachment ID
  # @attr_reader size [Integer, nil] The attachment size in bytes
  # @attr_reader filename [String, nil] The attachment filename
  # @attr_reader content_type [String, nil] The attachment MIME type
  # @attr_reader content_disposition [String, nil] attachment or inline
  # @attr_reader content_id [String, nil] The content ID for inline attachments
  # @attr_reader download_url [String, nil] Signed URL to download the attachment (only when fetched by ID)
  # @attr_reader download_url_expires_at [String, nil] When the download URL expires (only when fetched by ID)
  # rubocop:disable Lint/StructNewOverride -- +size+ is an API field that shadows Struct#size
  InboundAttachment = Struct.new(
    :attachment_id,
    :size,
    :filename,
    :content_type,
    :content_disposition,
    :content_id,
    :download_url,
    :download_url_expires_at,
    keyword_init: true
  )
  # rubocop:enable Lint/StructNewOverride
end
