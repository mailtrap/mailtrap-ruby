require 'mailtrap'

# --- Direct verification (e.g. for unit tests or custom routers) ----------
payload = '{"event":"delivery","message_id":"abc-123"}'
signing_secret = '8d9a3c0e7f5b2d4a6c1e9f8b3a7d5c2e'
signature = OpenSSL::HMAC.hexdigest('SHA256', signing_secret, payload)

verified = Mailtrap::Webhooks.verify_signature(
  payload: payload,
  signature: signature,
  signing_secret: signing_secret
)
# => true
raise 'Signature verification failed!' unless verified
