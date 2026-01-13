# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Project
  # @see https://api-docs.mailtrap.io/docs/mailtrap-api-docs/ee252e413d78a-create-project
  # @attr_reader id [Integer] The project ID
  # @attr_reader name [String] The project name
  # @attr_reader share_links [Hash] Admin and viewer share links
  # @attr_reader inboxes [Array<Mailtrap::Inbox>] Array of inboxes
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
