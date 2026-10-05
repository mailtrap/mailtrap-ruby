# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Template
  # @attr_reader id [Integer] The template ID
  # @attr_reader uuid [String] The template UUID
  # @attr_reader name [String] The template name
  # @attr_reader subject [String] The email subject
  # @attr_reader category [String] The template category
  # @attr_reader body_html [String] The HTML content
  # @attr_reader body_text [String] The plain text content
  # @attr_reader created_at [String] The creation timestamp
  # @attr_reader updated_at [String] The last update timestamp
  Template = Struct.new(
    :id,
    :uuid,
    :name,
    :subject,
    :category,
    :body_html,
    :body_text,
    :created_at,
    :updated_at,
    keyword_init: true
  )

  # Response from listing templates (paginated)
  # @attr_reader data [Array<Template>] Page of templates
  # @attr_reader pagination [Hash] Page-token pagination metadata
  #   (+token+, +prev_token+, +next_token+, +first_url+, +prev_url+, +current_url+, +next_url+)
  TemplatesListResponse = Struct.new(
    :data,
    :pagination,
    keyword_init: true
  )
end
