# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Sending Domain
  # @see https://docs.mailtrap.io/developers/management/sending-domains
  # @attr_reader id [Integer] The sending domain ID
  # @attr_reader domain_name [String] The sending domain name
  # @attr_reader dns_verified [Boolean] Whether the DNS is verified
  # @attr_reader compliance_status [String] The compliance status
  # @attr_reader created_at [String] The creation timestamp
  # @attr_reader updated_at [String] The last update timestamp
  #
  SendingDomain = Struct.new(
    :id,
    :domain_name,
    :dns_verified,
    :compliance_status,
    :created_at,
    :updated_at,
    keyword_init: true
  ) do
    # @return [Hash] The SendingDomain attributes as a hash
    def to_h
      super.compact
    end
  end
end
