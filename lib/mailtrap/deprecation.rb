# frozen_string_literal: true

require 'set'

module Mailtrap
  # Emits a deprecation warning once per process for each deprecated name, and maps the
  # deprecated inbox_id onto sandbox_id.
  # @api private
  module Deprecation
    WARNED = Set.new
    MUTEX = Mutex.new

    # Call it directly from the deprecated method: the warning points at that method's caller.
    # @param old_name [String] The deprecated name
    # @param new_name [String] The name to use instead
    def self.warn(old_name, new_name)
      return unless MUTEX.synchronize { WARNED.add?(old_name) }

      Kernel.warn(
        "[mailtrap] #{old_name} is deprecated and will be removed in a future major release; " \
        "use #{new_name} instead.",
        uplevel: 2
      )
    end

    # @param sandbox_id [Integer, String, nil] The ID given as sandbox_id
    # @param inbox_id [Integer, String] The ID given as the deprecated inbox_id
    # @return [Integer, String] The sandbox ID to use
    # @raise [ArgumentError] If both IDs are given and differ
    def self.resolve_sandbox_id(sandbox_id, inbox_id)
      return inbox_id if sandbox_id.nil?
      return sandbox_id if sandbox_id.to_s == inbox_id.to_s

      raise ArgumentError, 'sandbox_id and inbox_id differ; pass only sandbox_id'
    end
  end
end
