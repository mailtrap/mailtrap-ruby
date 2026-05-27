# frozen_string_literal: true

RSpec.describe Mailtrap::Webhooks do
  # ---------------------------------------------------------------------------
  # Cross-SDK fixture
  #
  # The (payload, signing_secret, expected_signature) triple below is the
  # canonical fixture shared verbatim by every official Mailtrap SDK
  # (mailtrap-ruby, mailtrap-python, mailtrap-php, mailtrap-nodejs,
  # mailtrap-java, mailtrap-dotnet). Any change here MUST be mirrored in the
  # equivalent test files in the other SDKs so the helpers stay byte-for-byte
  # compatible across languages.
  # ---------------------------------------------------------------------------
  let(:fixture_payload) do
    '{"event":"delivery","sending_stream":"transactional","category":"welcome",' \
      '"message_id":"a8b1d8f6-1f8d-4a3c-9b2e-1a2b3c4d5e6f",' \
      '"email":"recipient@example.com",' \
      '"event_id":"f1e2d3c4-b5a6-7890-1234-567890abcdef",' \
      '"timestamp":1716070000}'
  end
  let(:fixture_signing_secret) { '8d9a3c0e7f5b2d4a6c1e9f8b3a7d5c2e' }
  let(:fixture_expected_signature) { '6d262e2611cd09be1f948382b5c611d63b0e585c4c9c5e40139d6ac3876d5433' }

  describe '.verify_signature' do
    # --- 1. Valid signature for given payload + secret ----------------------
    context 'with a valid signature, payload and secret' do
      it 'returns true' do
        result = described_class.verify_signature(
          payload: fixture_payload,
          signature: fixture_expected_signature,
          signing_secret: fixture_signing_secret
        )

        expect(result).to be true
      end
    end

    # --- 2. Wrong secret ----------------------------------------------------
    context 'with a wrong signing secret' do
      it 'returns false' do
        result = described_class.verify_signature(
          payload: fixture_payload,
          signature: fixture_expected_signature,
          signing_secret: 'ffffffffffffffffffffffffffffffff'
        )

        expect(result).to be false
      end
    end

    # --- 3. Payload tampered (one byte changed) -----------------------------
    context 'when the payload is tampered with' do
      it 'returns false' do
        tampered = fixture_payload.sub('delivery', 'Delivery')

        result = described_class.verify_signature(
          payload: tampered,
          signature: fixture_expected_signature,
          signing_secret: fixture_signing_secret
        )

        expect(result).to be false
      end
    end

    # --- 4. Signature with wrong length -------------------------------------
    context 'with a signature of the wrong length' do
      it 'returns false without raising' do
        too_short = fixture_expected_signature[0..30]

        result = described_class.verify_signature(
          payload: fixture_payload,
          signature: too_short,
          signing_secret: fixture_signing_secret
        )

        expect(result).to be false
      end
    end

    # --- 5. Signature with non-hex characters -------------------------------
    context 'with non-hex characters in the signature' do
      it 'returns false without raising' do
        not_hex = 'z' * Mailtrap::Webhooks::SIGNATURE_HEX_LENGTH

        result = described_class.verify_signature(
          payload: fixture_payload,
          signature: not_hex,
          signing_secret: fixture_signing_secret
        )

        expect(result).to be false
      end
    end

    # --- 6. Empty signature string ------------------------------------------
    context 'with an empty signature' do
      it 'returns false' do
        result = described_class.verify_signature(
          payload: fixture_payload,
          signature: '',
          signing_secret: fixture_signing_secret
        )

        expect(result).to be false
      end
    end

    # --- 7. Empty signing_secret --------------------------------------------
    context 'with an empty signing secret' do
      it 'returns false' do
        result = described_class.verify_signature(
          payload: fixture_payload,
          signature: fixture_expected_signature,
          signing_secret: ''
        )

        expect(result).to be false
      end
    end

    # --- 8. Empty payload + non-empty signature -----------------------------
    context 'with an empty payload but a non-empty signature' do
      it 'returns false' do
        result = described_class.verify_signature(
          payload: '',
          signature: fixture_expected_signature,
          signing_secret: fixture_signing_secret
        )

        expect(result).to be false
      end
    end

    # --- 9. Known-good cross-SDK fixture ------------------------------------
    context 'when verifying the shared cross-SDK fixture' do
      it 'matches the hardcoded HMAC-SHA256 digest' do
        # Recompute the digest in-place so a regression in OpenSSL or the
        # fixture itself fails loudly: this is the byte-for-byte contract
        # every other Mailtrap SDK must satisfy.
        computed = OpenSSL::HMAC.hexdigest('SHA256', fixture_signing_secret, fixture_payload)

        expect(computed).to eq(fixture_expected_signature)
        expect(
          described_class.verify_signature(
            payload: fixture_payload,
            signature: fixture_expected_signature,
            signing_secret: fixture_signing_secret
          )
        ).to be true
      end
    end
  end
end
