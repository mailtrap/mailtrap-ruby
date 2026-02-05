# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for Sending Domain
  # @see https://docs.mailtrap.io/developers/management/sending-domains
  # @attr_reader id [Integer] The sending domain ID
  # @attr_reader domain_name [String] The sending domain name
  # @attr_reader demo [Boolean] Whether the sending domain is a demo domain
  # @attr_reader compliance_status [String] The compliance status of the sending domain
  # @attr_reader dns_verified [Boolean] Whether the DNS records are verified
  # @attr_reader dns_verified_at [String, nil] The timestamp when DNS was verified
  # @attr_reader dns_records [Array] The DNS records for the sending domain
  # @attr_reader open_tracking_enabled [Boolean] Whether open tracking is enabled
  # @attr_reader click_tracking_enabled [Boolean] Whether click tracking is enabled
  # @attr_reader auto_unsubscribe_link_enabled [Boolean] Whether auto unsubscribe link is enabled
  # @attr_reader custom_domain_tracking_enabled [Boolean] Whether custom domain tracking is enabled
  # @attr_reader health_alerts_enabled [Boolean] Whether health alerts are enabled
  # @attr_reader critical_alerts_enabled [Boolean] Whether critical alerts are enabled
  # @attr_reader alert_recipient_email [String, nil] The email address for alert recipients
  # @attr_reader permissions [Hash] The permissions for the sending domain
  #
  SendingDomain = Struct.new(
    :id,
    :domain_name,
    :demo,
    :compliance_status,
    :dns_verified,
    :dns_verified_at,
    :dns_records,
    :open_tracking_enabled,
    :click_tracking_enabled,
    :auto_unsubscribe_link_enabled,
    :custom_domain_tracking_enabled,
    :health_alerts_enabled,
    :critical_alerts_enabled,
    :alert_recipient_email,
    :permissions,
    :created_at,
    :updated_at,
    keyword_init: true
  )
end
