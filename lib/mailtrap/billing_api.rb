# frozen_string_literal: true

require_relative 'base_api'
require_relative 'billing'

module Mailtrap
  class BillingAPI
    include BaseAPI

    self.response_class = Billing

    # Show billing details for the account
    # @return <Billing> Billing data for account
    # @!macro api_errors
    def get
      response = client.get(base_path)
      handle_response(response)
    end

    private

    def base_path
      "/api/accounts/#{account_id}/billing/usage"
    end
  end
end
