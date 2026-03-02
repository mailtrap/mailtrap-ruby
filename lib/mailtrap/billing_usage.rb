# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Billing Usage data
  # @see https://docs.mailtrap.io/developers/account-management/billing
  # @attr_reader billing [Hash] The billing cycle details
  # @attr_reader testing [Hash] Testing subscription usage
  # @attr_reader sending [Hash] Sending subscription usage
  #
  BillingUsage = Struct.new(
    :billing,
    :testing,
    :sending,
    keyword_init: true
  )
end
