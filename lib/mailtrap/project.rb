# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Project
  # @see https://docs.mailtrap.io/developers/email-sandbox/projects
  # @attr_reader id [Integer] The project ID
  # @attr_reader name [String] The project name
  # @attr_reader share_links [Hash] Admin and viewer share links
  # @attr_reader inboxes [Array<Mailtrap::Sandbox>] Array of the project's sandboxes
  # @attr_reader permissions [Hash] List of permissions
  #
  Project = Struct.new(
    :id,
    :name,
    :share_links,
    :inboxes,
    :permissions,
    keyword_init: true
  )
end
