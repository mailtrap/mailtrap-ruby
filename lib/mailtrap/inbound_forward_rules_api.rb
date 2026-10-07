# frozen_string_literal: true

require_relative 'base_api'
require_relative 'inbound_forward_rule'
require_relative 'inbound_forward_rule_condition'
require_relative 'inbound_forward_rule_destination'

module Mailtrap
  class InboundForwardRulesAPI
    include BaseAPI

    self.supported_options = %i[name conditions destinations]
    self.response_class = InboundForwardRule

    # @param client [Mailtrap::Client] The client instance
    def initialize(client = Mailtrap::Client.new)
      @client = client
    end

    # Lists forward rules in an inbox
    # @param inbox_id [Integer] The inbox ID
    # @return [Array<InboundForwardRule>] Array of forward rules
    # @!macro api_errors
    def list(inbox_id)
      response = client.get(forward_rules_path(inbox_id))
      Array(response[:data]).map { |item| build_rule(item) }
    end

    # Retrieves a specific forward rule
    # @param inbox_id [Integer] The inbox ID
    # @param forward_rule_id [Integer] The forward rule ID
    # @return [InboundForwardRule] Forward rule object
    # @!macro api_errors
    def get(inbox_id, forward_rule_id)
      handle_response(client.get("#{forward_rules_path(inbox_id)}/#{forward_rule_id}"))
    end

    # Creates a new forward rule
    # @param inbox_id [Integer] The inbox ID
    # @param [Hash] options The parameters to create
    # @option options [String] :name The rule name
    # @option options [Array<Hash>] :conditions The rule conditions
    # @option options [Array<Hash>] :destinations The rule destinations
    # @return [InboundForwardRule] Created forward rule
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def create(inbox_id, options)
      validate_options!(options, supported_options)
      handle_response(client.post(forward_rules_path(inbox_id), options))
    end

    # Updates a forward rule
    # @param inbox_id [Integer] The inbox ID
    # @param forward_rule_id [Integer] The forward rule ID
    # @param [Hash] options The parameters to update
    # @option options [String] :name The rule name
    # @option options [Array<Hash>] :conditions The rule conditions
    # @option options [Array<Hash>] :destinations The rule destinations
    # @return [InboundForwardRule] Updated forward rule
    # @!macro api_errors
    # @raise [ArgumentError] If invalid options are provided
    def update(inbox_id, forward_rule_id, options)
      validate_options!(options, supported_options)
      handle_response(client.patch("#{forward_rules_path(inbox_id)}/#{forward_rule_id}", options))
    end

    # Deletes a forward rule
    # @param inbox_id [Integer] The inbox ID
    # @param forward_rule_id [Integer] The forward rule ID
    # @return nil
    # @!macro api_errors
    def delete(inbox_id, forward_rule_id)
      client.delete("#{forward_rules_path(inbox_id)}/#{forward_rule_id}")
    end

    private

    def forward_rules_path(inbox_id)
      "/api/inbound/inboxes/#{inbox_id}/forward_rules"
    end

    def handle_response(response)
      build_rule(response[:data])
    end

    def build_rule(hash)
      attrs = hash.slice(*InboundForwardRule.members)
      attrs[:conditions] = build_conditions(attrs[:conditions]) if attrs[:conditions]
      attrs[:destinations] = build_destinations(attrs[:destinations]) if attrs[:destinations]

      InboundForwardRule.new(**attrs)
    end

    def build_conditions(conditions)
      Array(conditions).map do |condition|
        InboundForwardRuleCondition.new(**condition.slice(*InboundForwardRuleCondition.members))
      end
    end

    def build_destinations(destinations)
      Array(destinations).map do |destination|
        InboundForwardRuleDestination.new(**destination.slice(*InboundForwardRuleDestination.members))
      end
    end
  end
end
