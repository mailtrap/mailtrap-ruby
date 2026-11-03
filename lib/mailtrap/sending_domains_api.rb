# frozen_string_literal: true

require_relative 'deprecation'
require_relative 'domains_api'
require_relative 'sending_domain'

module Mailtrap
  # @deprecated Use {DomainsAPI} instead.
  class SendingDomainsAPI < DomainsAPI
    def initialize(*)
      Deprecation.warn('Mailtrap::SendingDomainsAPI', 'Mailtrap::DomainsAPI')
      super
    end
  end
end
