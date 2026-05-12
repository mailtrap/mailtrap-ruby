# frozen_string_literal: true

require_relative 'base_api'
require_relative 'webhook'

module Mailtrap
  class WebhooksAPI
    include BaseAPI

    self.supported_options = %i[url webhook_type active payload_format sending_stream event_types domain_id]

    self.response_class = Webhook

    # Lists all webhooks for the account
    # @return [Array<Webhook>] Array of webhooks
    # @!macro api_errors
    def list
      response = client.get(base_path)
      response[:data].map { |item| build_entity(item, response_class) }
    end

    # Retrieves a specific webhook
    # @param webhook_id [Integer] The webhook ID
    # @return [Webhook] Webhook object
    # @!macro api_errors
    def get(webhook_id)
      base_get(webhook_id)
    end

    # Creates a new webhook
    # @param [Hash] options The parameters to create
    # @option options [String] :url The URL that will receive webhook payloads
    # @option options [String] :webhook_type The type of webhook (`email_sending` or `audit_log`)
    # @option options [Boolean] :active Whether the webhook is active. Defaults to true.
    # @option options [String] :payload_format Payload format (`json` or `jsonlines`). Defaults to `json`.
    # @option options [String] :sending_stream Sending stream (`transactional` or `bulk`).
    #   Required for `email_sending` webhook type.
    # @option options [Array<String>] :event_types Event types to subscribe to.
    #   Required for `email_sending` webhook type.
    # @option options [Integer] :domain_id Sending domain ID to scope the webhook to.
    #   Applicable only for `email_sending` webhooks.
    # @return [Webhook] Created webhook (includes `signing_secret`)
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(options)
      base_create(options)
    end

    # Updates an existing webhook
    # @param webhook_id [Integer] The webhook ID
    # @param [Hash] options The parameters to update
    # @option options [String] :url The URL that will receive webhook payloads
    # @option options [Boolean] :active Whether the webhook is active
    # @option options [String] :payload_format Payload format (`json` or `jsonlines`)
    # @option options [Array<String>] :event_types Event types to subscribe to.
    #   Applicable only for `email_sending` webhooks.
    # @return [Webhook] Updated webhook
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def update(webhook_id, options)
      base_update(webhook_id, options, %i[url active payload_format event_types])
    end

    # Deletes a webhook
    # @param webhook_id [Integer] The webhook ID
    # @return [Webhook] Deleted webhook
    # @!macro api_errors
    def delete(webhook_id)
      response = client.delete("#{base_path}/#{webhook_id}")
      handle_response(response) if response
    end

    private

    def base_path
      "/api/accounts/#{account_id}/webhooks"
    end

    def wrap_request(options)
      { webhook: options }
    end

    def handle_response(response)
      build_entity(response[:data], response_class)
    end
  end
end
