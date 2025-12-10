# frozen_string_literal: true

module Mailtrap
  class Project
    # Data Transfer Object for Project
    # @see https://api-docs.mailtrap.io/docs/mailtrap-api-docs/ee252e413d78a-create-project
    # @attr_reader id [Integer] The project ID
    # @attr_reader name [String] The project name
    # @attr_reader share_links [Hash] Admin and viewer share links
    # @attr_reader inboxes [Array<Mailtrap::Inbox>] Array of inboxes
    # @attr_reader permissions [Hash] List of permissions
    attr_reader :id, :name, :share_links, :inboxes, :permissions

    def self.members
      %i[id name share_links inboxes permissions]
    end

    # @param args [Hash] The project attributes
    def initialize(args = {})
      @id          = args[:id]
      @name        = args[:name]
      @share_links = args[:share_links]
      @permissions = args[:permissions]

      raw_inboxes = args[:inboxes]
      @inboxes =
        raw_inboxes&.map do |inbox|
          inbox.is_a?(Mailtrap::Inbox) ? inbox : Mailtrap::Inbox.new(**inbox)
        end
    end

    # @return [Hash] The project attributes as a hash
    def to_h
      {
        id: id,
        name: name,
        share_links: share_links,
        inboxes: inboxes&.map(&:to_h),
        permissions: permissions
      }.compact
    end
  end
end
