# frozen_string_literal: true

require 'set'

module Mailtrap
  # Emits a deprecation warning once per process for each deprecated name.
  # @api private
  module Deprecation
    WARNED = Set.new
    MUTEX = Mutex.new

    # Call it directly from the deprecated method: the warning points at that method's caller.
    # @param old_name [String] The deprecated name
    # @param new_name [String] The name to use instead
    def self.warn(old_name, new_name)
      return if WARNED.include?(old_name)
      return unless MUTEX.synchronize { WARNED.add?(old_name) }

      Kernel.warn(
        "[mailtrap] #{old_name} is deprecated and will be removed in a future major release; " \
        "use #{new_name} instead.",
        uplevel: 2
      )
    end
  end
end
