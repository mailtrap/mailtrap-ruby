# Run with: `rackup examples/webhooks_signature_verification.ru`

require 'mailtrap'
require 'rack'

# Your webhook signing secret, returned by `WebhooksAPI#create`.
# Load it from your environment or secret manager — never hardcode it.
SIGNING_SECRET = ENV.fetch('MAILTRAP_WEBHOOK_SIGNING_SECRET')

app = lambda do |env|
  request = Rack::Request.new(env)

  unless request.post? && request.path == '/webhooks/mailtrap'
    next [404, { 'content-type' => 'text/plain' }, ['Not Found']]
  end

  # Use the raw request body — parsing and re-serializing the JSON may
  # reorder keys or alter whitespace and invalidate the signature.
  payload   = request.body.read
  signature = env['HTTP_MAILTRAP_SIGNATURE']

  unless Mailtrap::Webhooks.verify_signature(
    payload: payload,
    signature: signature,
    signing_secret: SIGNING_SECRET
  )
    next [401, { 'content-type' => 'text/plain' }, ['Invalid signature']]
  end

  # Signature verified — safe to parse and handle the event.
  [200, { 'content-type' => 'text/plain' }, ['']]
end

run app
