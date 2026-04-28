# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Sending Domain Company Info
  # @see https://docs.mailtrap.io/developers/management/sending-domains
  # @attr_reader name [String, nil] Company or individual name
  # @attr_reader address [String, nil] Street address
  # @attr_reader city [String, nil] City
  # @attr_reader country [String, nil] Country
  # @attr_reader phone [String, nil] Phone number
  # @attr_reader zip_code [String, nil] ZIP or postal code
  # @attr_reader privacy_policy_url [String, nil] URL to the privacy policy page
  # @attr_reader terms_of_service_url [String, nil] URL to the terms of service page
  # @attr_reader website_url [String, nil] Company website URL or LinkedIn / personal website
  # @attr_reader info_level [String, nil] Whether the sender is a "business" or "individual"
  CompanyInfo = Struct.new(
    :name,
    :address,
    :city,
    :country,
    :phone,
    :zip_code,
    :privacy_policy_url,
    :terms_of_service_url,
    :website_url,
    :info_level,
    keyword_init: true
  )
end
