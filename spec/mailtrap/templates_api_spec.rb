# frozen_string_literal: true

RSpec.describe Mailtrap::TemplatesAPI do
  subject(:templates_api) { described_class.new(1_111_111, Mailtrap::Client.new(api_key: 'correct-api-key')) }

  let(:base_url) { 'https://mailtrap.io/api/accounts/1111111/templates' }
  let(:json_headers) { { 'Content-Type' => 'application/json' } }
  let(:template_attributes) do
    {
      'id' => 26_730,
      'uuid' => '018dd5e3-f6d2-7c00-8f9b-e5c3f2d8a132',
      'name' => 'Welcome Email',
      'subject' => 'Welcome!',
      'category' => 'Welcome',
      'body_html' => '<div>Hi</div>',
      'body_text' => 'Hi',
      'created_at' => '2021-01-01T00:00:00Z',
      'updated_at' => '2021-01-01T00:00:00Z'
    }
  end

  describe '#list' do
    let(:pagination) do
      { 'token' => 1, 'prev_token' => nil, 'next_token' => 2, 'first_url' => "#{base_url}?token=1" }
    end

    it 'returns a paginated list of Template objects' do
      stub_request(:get, base_url)
        .to_return(
          status: 200,
          body: { 'data' => [template_attributes], 'pagination' => pagination }.to_json,
          headers: json_headers
        )

      response = templates_api.list
      expect(response).to be_a(Mailtrap::TemplatesListResponse)
      expect(response.data).to all(be_a(Mailtrap::Template))
      expect(response.data.first).to have_attributes(id: 26_730, name: 'Welcome Email', category: 'Welcome')
      expect(response.pagination).to eq(
        token: 1, prev_token: nil, next_token: 2, first_url: "#{base_url}?token=1"
      )
    end

    it 'passes pagination params' do
      stub = stub_request(:get, base_url)
             .with(query: { per_page: '10', token: '2' })
             .to_return(
               status: 200,
               body: { 'data' => [], 'pagination' => { 'token' => 2 } }.to_json,
               headers: json_headers
             )

      response = templates_api.list(per_page: 10, token: 2)
      expect(stub).to have_been_requested
      expect(response.data).to eq([])
    end

    it 'raises error when the token is out of range' do
      stub_request(:get, base_url)
        .with(query: { token: '99' })
        .to_return(status: 422, body: { 'errors' => 'token is out of range' }.to_json, headers: json_headers)

      expect { templates_api.list(token: 99) }.to raise_error(Mailtrap::Error, /token is out of range/)
    end

    it 'raises error when api key is incorrect' do
      stub_request(:get, base_url)
        .to_return(status: 401, body: { 'error' => 'Incorrect API token' }.to_json, headers: json_headers)

      expect { templates_api.list }.to raise_error(Mailtrap::AuthorizationError, /Incorrect API token/)
    end
  end

  describe '#get' do
    it 'returns a Template object' do
      stub_request(:get, "#{base_url}/26730")
        .to_return(status: 200, body: { 'data' => template_attributes }.to_json, headers: json_headers)

      response = templates_api.get(26_730)
      expect(response).to be_a(Mailtrap::Template)
      expect(response).to have_attributes(id: 26_730, uuid: '018dd5e3-f6d2-7c00-8f9b-e5c3f2d8a132')
    end

    it 'raises error when the template does not exist' do
      stub_request(:get, "#{base_url}/999")
        .to_return(status: 404, body: { 'error' => 'Not Found' }.to_json, headers: json_headers)

      expect { templates_api.get(999) }.to raise_error(Mailtrap::Error, /Not Found/)
    end
  end

  describe '#create' do
    let(:request) do
      { name: 'Welcome Email', subject: 'Welcome!', category: 'Welcome', body_html: '<div>Hi</div>' }
    end

    it 'sends a flat request body and returns the created Template' do
      stub = stub_request(:post, base_url)
             .with(body: request.to_json)
             .to_return(status: 201, body: { 'data' => template_attributes }.to_json, headers: json_headers)

      response = templates_api.create(request)
      expect(stub).to have_been_requested
      expect(response).to be_a(Mailtrap::Template)
      expect(response).to have_attributes(id: 26_730, name: 'Welcome Email')
    end

    it 'raises ArgumentError when invalid options are provided' do
      expect { templates_api.create(name: 'Welcome Email', unknown_option: true) }
        .to raise_error(ArgumentError, /invalid options are given/)
    end

    it 'raises error when validation fails' do
      stub_request(:post, base_url)
        .to_return(
          status: 422,
          body: { 'errors' => { 'subject' => ["can't be blank"] } }.to_json,
          headers: json_headers
        )

      expect { templates_api.create(name: 'Welcome Email') }.to raise_error(Mailtrap::Error, /subject/)
    end
  end

  describe '#update' do
    let(:request) { { name: 'Welcome Email (updated)', subject: 'Welcome aboard!' } }

    it 'sends a flat PATCH request body and returns the updated Template' do
      stub = stub_request(:patch, "#{base_url}/26730")
             .with(body: request.to_json)
             .to_return(
               status: 200,
               body: { 'data' => template_attributes.merge('name' => 'Welcome Email (updated)') }.to_json,
               headers: json_headers
             )

      response = templates_api.update(26_730, request)
      expect(stub).to have_been_requested
      expect(response).to have_attributes(id: 26_730, name: 'Welcome Email (updated)')
    end

    it 'raises ArgumentError when invalid options are provided' do
      expect { templates_api.update(26_730, unknown_option: true) }
        .to raise_error(ArgumentError, /invalid options are given/)
    end

    it 'raises error when validation fails' do
      stub_request(:patch, "#{base_url}/26730")
        .to_return(
          status: 422,
          body: { 'errors' => { 'name' => ["can't be blank"] } }.to_json,
          headers: json_headers
        )

      expect { templates_api.update(26_730, name: '') }.to raise_error(Mailtrap::Error, /name/)
    end
  end

  describe '#delete' do
    it 'deletes the template and returns nil' do
      stub_request(:delete, "#{base_url}/26730").to_return(status: 204)

      expect(templates_api.delete(26_730)).to be_nil
    end

    it 'raises error when the template does not exist' do
      stub_request(:delete, "#{base_url}/999")
        .to_return(status: 404, body: { 'error' => 'Not Found' }.to_json, headers: json_headers)

      expect { templates_api.delete(999) }.to raise_error(Mailtrap::Error, /Not Found/)
    end
  end
end
