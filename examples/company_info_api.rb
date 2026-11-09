require 'mailtrap'

account_id = 3229
domain_id = 1
client = Mailtrap::Client.new(api_key: 'your-api-key')
company_info_api = Mailtrap::CompanyInfoAPI.new(account_id, client)

# Create company info for a domain
company_info_api.create(
  domain_id,
  name: 'Mailtrap',
  address: '123 Main St',
  city: 'San Francisco',
  country: 'US',
  zip_code: '94105',
  website_url: 'https://mailtrap.io',
  info_level: 'business'
)
# => #<struct Mailtrap::CompanyInfo name="Mailtrap", address="123 Main St", ...>
