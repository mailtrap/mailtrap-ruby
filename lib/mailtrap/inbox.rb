# frozen_string_literal: true

require_relative 'sandbox'

module Mailtrap
  # @deprecated Use {Sandbox} instead.
  Inbox = Sandbox
  deprecate_constant :Inbox
end
