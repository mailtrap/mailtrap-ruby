# frozen_string_literal: true

require_relative 'base_api'
require_relative 'template'

module Mailtrap
  # @note Experimental: the +/api/templates+ endpoints may change their request and response
  #   shapes before general availability.
  class TemplatesAPI
    include BaseAPI

    self.supported_options = %i[name subject category body_html body_text]

    self.response_class = Template

    # Lists templates for the account, one page at a time
    # @param per_page [Integer, nil] Number of templates per page (max 100, default 50)
    # @param token [Integer, nil] Page number to retrieve (page-token pagination, default 1)
    # @return [TemplatesListResponse] The page of templates and pagination metadata
    # @!macro api_errors
    def list(per_page: nil, token: nil)
      query_params = {}
      query_params[:per_page] = per_page unless per_page.nil?
      query_params[:token] = token unless token.nil?

      response = client.get(base_path, query_params)

      TemplatesListResponse.new(
        data: Array(response[:data]).map { |item| build_entity(item, response_class) },
        pagination: response[:pagination]
      )
    end

    # Retrieves a specific template
    # @param template_id [Integer] The template ID
    # @return [Template] Template object
    # @!macro api_errors
    def get(template_id)
      base_get(template_id)
    end

    # Creates a new template
    # @param [Hash] options The parameters to create
    # @option options [String] :name The template name (required)
    # @option options [String] :subject The email subject (required)
    # @option options [String] :category The template category (required)
    # @option options [String, nil] :body_html The HTML content. Default: nil.
    # @option options [String, nil] :body_text The plain text content. Default: nil.
    # @return [Template] Created template object
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(options)
      base_create(options)
    end

    # Updates an existing template. Only the provided attributes are changed.
    # @param template_id [Integer] The template ID
    # @param [Hash] options The parameters to update
    # @option options [String] :name The template name
    # @option options [String] :subject The email subject
    # @option options [String] :category The template category
    # @option options [String, nil] :body_html The HTML content
    # @option options [String, nil] :body_text The plain text content
    # @return [Template] Updated template object
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def update(template_id, options)
      base_update(template_id, options)
    end

    # Deletes a template
    # @param template_id [Integer] The template ID
    # @return [nil]
    # @!macro api_errors
    def delete(template_id)
      base_delete(template_id)
    end

    private

    def base_path
      "/api/accounts/#{account_id}/templates"
    end

    def handle_response(response)
      build_entity(response[:data], response_class)
    end
  end
end
