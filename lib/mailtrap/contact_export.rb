# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Contact Export
  # @attr_reader id [Integer] The contact export ID
  # @attr_reader status [String] The export status (created, started, finished)
  # @attr_reader created_at [String] When the export was created
  # @attr_reader updated_at [String] When the export was last updated
  # @attr_reader url [String, nil] URL of the exported file (only when status is "finished")
  ContactExport = Struct.new(
    :id,
    :status,
    :created_at,
    :updated_at,
    :url,
    keyword_init: true
  )
end
