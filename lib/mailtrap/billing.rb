# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Billing data
  # @see https://docs.mailtrap.io/developers/account-management/billing
  # @attr_reader billing [Hash] The billing cycles
  # @attr_reader testing [Hash] Testing subscription details
  # @attr_reader sending [Hash] Sending subscription details
  #
  Billing = Struct.new(
    :billing,
    :testing,
    :sending,
    keyword_init: true
  )
end
