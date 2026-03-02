# frozen_string_literal: true

require_relative 'base_api'
require_relative 'billing_usage'

module Mailtrap
  class BillingAPI
    include BaseAPI

    # Get current billing cycle usage
    # @return [BillingUsage] Billing usage data for account
    # @!macro api_errors
    def usage
      response = client.get("/api/accounts/#{account_id}/billing/usage")
      build_entity(response, BillingUsage)
    end
  end
end
