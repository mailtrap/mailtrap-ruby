## [2.0.0] - 2024-03-20

- Added arguments for `Mailtrap::Client`
  - `bulk` to use Mailtrap bulk sending API
  - `sandbox` to use Mailtrap sandbox API
  - `inbox_id` required when using Mailtrap sandbox API

- Removed Sending namespace, affected classes:
  - `Mailtrap::Sending::Client` -> `Mailtrap::Client`
  - `Mailtrap::Sending::Error` -> `Mailtrap::Error`
  - `Mailtrap::Sending::AttachmentContentError` -> `Mailtrap::AttachmentContentError`
  - `Mailtrap::Sending::AuthorizationError` -> `Mailtrap::AuthorizationError`
  - `Mailtrap::Sending::MailSizeError` -> `Mailtrap::MailSizeError`
  - `Mailtrap::Sending::RateLimitError` -> `Mailtrap::RateLimitError`
  - `Mailtrap::Sending::RejectionError` -> `Mailtrap::RejectionError`

## [1.2.2] - 2023-11-01

- Improved error handling

## [1.2.1] - 2023-04-12

- Set custom user agent

## [1.2.0] - 2023-01-27

- Breaking changes:
  - move `Mailtrap::Sending::Mail` class to `Mailtrap::Mail::Base`
  - move `Mailtrap::Sending::Convert` to `Mailtrap::Mail`
- Add mail gem 2.8 support
- Add email template support

## [1.1.1] - 2022-10-14

- Fix custom port and host usage

## [1.1.0] - 2022-07-22

- Add ActionMailer support

## [1.0.1] - 2022-06-20

- Update packed files list

## [1.0.0] - 2022-06-14

- Initial release
