# frozen_string_literal: true

require_relative 'domain'

module Mailtrap
  # @deprecated Use {Domain} instead.
  SendingDomain = Domain
  deprecate_constant :SendingDomain
end
