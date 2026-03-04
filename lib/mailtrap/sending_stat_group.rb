# frozen_string_literal: true

module Mailtrap
  # Data Transfer Object for grouped Sending Stats data
  # @attr_reader name [Symbol] Group type (:category, :date, :sending_domain_id, :email_service_provider)
  # @attr_reader value [String, Integer] Group value (e.g., "Transactional", "2026-01-01", 1, "Gmail")
  # @attr_reader stats [SendingStats] Sending stats for this group
  #
  SendingStatGroup = Struct.new(
    :name,
    :value,
    :stats,
    keyword_init: true
  )
end
