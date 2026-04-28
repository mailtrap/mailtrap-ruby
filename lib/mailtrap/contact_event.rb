# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Contact Event
  # @attr_reader contact_id [String] The contact ID (UUID)
  # @attr_reader contact_email [String] The contact email
  # @attr_reader name [String] The event name
  # @attr_reader params [Hash] The event parameters (string keys, scalar values)
  ContactEvent = Struct.new(
    :contact_id,
    :contact_email,
    :name,
    :params,
    keyword_init: true
  )
end
