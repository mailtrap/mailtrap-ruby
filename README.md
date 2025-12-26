# Mailtrap Ruby client - Official

![Ruby](https://img.shields.io/badge/Ruby-CC342D)
[![test](https://github.com/mailtrap/mailtrap-ruby/actions/workflows/main.yml/badge.svg)](https://github.com/mailtrap/mailtrap-ruby/actions/workflows/main.yml)
[![docs](https://shields.io/badge/docs-rubydoc.info-blue)](https://rubydoc.info/gems/mailtrap)
[![gem](https://shields.io/gem/v/mailtrap)](https://rubygems.org/gems/mailtrap)
[![downloads](https://shields.io/gem/dt/mailtrap)](https://rubygems.org/gems/mailtrap)


## Prerequisites

To get the most out of this official Mailtrap.io Ruby SDK:

- [Create a Mailtrap account](https://mailtrap.io/signup)

- [Verify your domain](https://mailtrap.io/sending/domains)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mailtrap'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install mailtrap

## Usage

### Ruby on Rails

```ruby
# place this code in config/environments/production.rb:
config.action_mailer.delivery_method = :mailtrap

# then set the MAILTRAP_API_KEY environment variable
# using your hosting solution.
```

### Pure Ruby

```ruby
require 'mailtrap'

# Create mail object
mail = Mailtrap::Mail.from_content(
  from: { email: 'mailtrap@example.com', name: 'Mailtrap Test' },
  to: [
    { email: 'your@email.com' }
  ],
  reply_to: { email: 'support@example.com', name: 'Mailtrap Reply-To' },
  subject: 'You are awesome!',
  text: 'Congrats for sending test email with Mailtrap!'
)

# Create client and send
client = Mailtrap::Client.new(api_key: 'your-api-key')
client.send(mail)

# You can also pass the request parameters directly
client.send(
  from: { email: 'mailtrap@example.com', name: 'Mailtrap Test' },
  to: [
    { email: 'your@email.com' }
  ],
  subject: 'You are awesome!',
  text: 'Congrats for sending test email with Mailtrap!'
)

```

### Batch Sending

Send up to 500 emails in one API call:

```ruby
require 'mailtrap'

client = Mailtrap::Client.new(api_key: 'your-api-key')

batch_base = Mailtrap::Mail.batch_base_from_content(
  from: { email: 'mailtrap@demomailtrap.co', name: 'Mailtrap Test' },
  subject: 'You are awesome!',
  text: 'Congrats for sending test email with Mailtrap!',
  html: '<p>Congrats for sending test email with Mailtrap!</p>'
)

client.send_batch(
  batch_base, [
    Mailtrap::Mail.from_content(
      to: [
        { email: 'john.doe@email.com', name: 'John Doe' }
      ]
    ),
    Mailtrap::Mail.from_content(
      to: [
        { email: 'jane.doe@email.com', name: 'Jane Doe' }
      ]
    )
  ]
)
```

### Sandbox Sending

Send emails to your Sandbox inbox for testing purposes:

```ruby
require 'mailtrap'

client = Mailtrap::Client.new(api_key: 'your-api-key', sandbox: true, inbox_id: YOUR_INBOX_ID)
client.send(mail)

# You can also pass the request parameters directly
client.send(
  from: { email: 'mailtrap@example.com', name: 'Mailtrap Test' },
  to: [
    { email: 'your@email.com' }
  ],
  subject: 'You are awesome!',
  text: 'Congrats for sending test email with Mailtrap!'
)
```

### Content-Transfer-Encoding

`mailtrap` gem uses Mailtrap API to send emails. Mailtrap API does not try to
replicate SMTP. That is why you should expect some limitations when it comes to
sending. For example, `/api/send` endpoint ignores `Content-Transfer-Encoding`
(see `headers` in the [API documentation](https://railsware.stoplight.io/docs/mailtrap-api-docs/67f1d70aeb62c-send-email)).
Meaning your recipients will receive emails only in the default encoding which
is `quoted-printable`, if you send with Mailtrap API.

For those who need to use `7bit` or any other encoding, SMTP provides
better flexibility in that regard. Go to your _Mailtrap account_ → _Email Sending_
→ _Sending Domains_ → _Your domain_ → _SMTP/API Settings_ to find the SMTP
configuration example.

### Multiple Mailtrap Clients

You can configure two Mailtrap clients to operate simultaneously. This setup is
particularly useful when you need to send emails using both the transactional
and bulk APIs. Refer to the configuration examples above.

## Supported functionality & Examples

Refer to the [`examples`](examples) folder for more examples:

Email API:
- Full email sending – [`full.rb`](examples/full.rb)

- Batch sending – [`batch.rb`](examples/batch.rb)

Email Sandbox (Testing):

- Project management CRUD – [`projects_api.rb`](examples/projects_api.rb)

Contact management:

- Contacts CRUD & listing – [`contacts_api.rb`](examples/contacts_api.rb)

General API:

- Templates CRUD – [`email_templates_api.rb`](examples/email_templates_api.rb)

- Action Mailer – [`action_mailer.rb`](examples/action_mailer.rb)

## Migration guide v1 → v2

Change `Mailtrap::Sending::Client` to `Mailtrap::Client`.

If you use classes which have `Sending` namespace, remove the namespace like in the example above.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/railsware/mailtrap-ruby). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](CODE_OF_CONDUCT.md).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

All contributions are required to have rspec tests covering its functionality.

Please be sure to update [README](README.md) with new examples and features when applicable.

## License

The package is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mailtrap project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Compatibility with previous releases

Versions of this package up to 2.0.2 were an [unofficial client](https://github.com/vchin/mailtrap-client) developed by [@vchin](https://github.com/vchin). Package version 3 is a completely new package. 