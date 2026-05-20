# frozen_string_literal: true

require 'openssl'

module Mailtrap
  # Helpers for working with inbound Mailtrap webhooks.
  #
  # @see https://docs.mailtrap.io/email-api-smtp/advanced/webhooks#verifying-the-signature
  module Webhooks
    # Hex-encoded HMAC-SHA256 signature length.
    SIGNATURE_HEX_LENGTH = 64

    # Verifies the HMAC-SHA256 signature of a Mailtrap webhook payload.
    #
    # Mailtrap signs every outbound webhook by computing
    # `HMAC-SHA256(signing_secret, raw_request_body)` and sending the lowercase
    # hex digest in the `Mailtrap-Signature` HTTP header. Compute the same
    # digest on your side and compare it in constant time.
    #
    # The comparison is performed with {OpenSSL.fixed_length_secure_compare} to
    # avoid timing side-channels.
    #
    # The method never raises on inputs that could plausibly arrive over the
    # wire (empty strings, wrong-length signatures, non-hex characters, missing
    # secret) — it simply returns `false`. This makes it safe to call directly
    # from a controller without rescuing.
    #
    # @param payload [String] The raw request body, exactly as received.
    #   **Do not** parse and re-serialize the JSON — re-encoding may reorder
    #   keys or alter whitespace and invalidate the signature.
    # @param signature [String] The value of the `Mailtrap-Signature` HTTP
    #   header (lowercase hex string).
    # @param signing_secret [String] The webhook's `signing_secret`, returned
    #   by {WebhooksAPI#create} on webhook creation.
    # @return [Boolean] `true` if the signature is valid for the given payload
    #   and secret, `false` otherwise.
    def self.verify_signature(payload:, signature:, signing_secret:)
      return false unless [payload, signature, signing_secret].all? { |v| v.is_a?(String) && !v.empty? }
      return false if signature.bytesize != SIGNATURE_HEX_LENGTH

      expected = OpenSSL::HMAC.hexdigest('SHA256', signing_secret, payload)

      OpenSSL.fixed_length_secure_compare(expected, signature)
    rescue ArgumentError
      # fixed_length_secure_compare raises ArgumentError on length mismatch
      false
    end
  end
end
