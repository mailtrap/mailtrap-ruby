# frozen_string_literal: true

require_relative 'deprecation'
require_relative 'sandboxes_api'
require_relative 'inbox'

module Mailtrap
  # @deprecated Use {SandboxesAPI} instead.
  class InboxesAPI < SandboxesAPI
    def initialize(*)
      Deprecation.warn('Mailtrap::InboxesAPI', 'Mailtrap::SandboxesAPI')
      super
    end
  end
end
