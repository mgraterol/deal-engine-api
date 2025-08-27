# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integrations::Amadeus::Client do # rubocop:disable Metrics/BlockLength
  subject(:client) { described_class.new }

  # Use let to define mock ENV variables
  let(:amadeus_client_id) { 'test_client_id' }
  let(:amadeus_client_secret) { 'test_client_secret' }

  # Mock ENV variables for each test
  before do
    allow(ENV).to receive(:[]).with('AMADEUS_CLIENT_ID').and_return(amadeus_client_id)
    allow(ENV).to receive(:[]).with('AMADEUS_CLIENT_SECRET').and_return(amadeus_client_secret)
  end

  describe '#access_token' do # rubocop:disable Metrics/BlockLength
    context 'when the API call is successful' do # rubocop:disable Metrics/BlockLength
      let(:mock_response) do
        {
          'access_token' => 'mock_token_12345',
          'token_type' => 'Bearer',
          'expires_in' => 1799
        }
      end

      before do
        # Mock the HTTParty post request to return a fake response
        allow(Integrations::Amadeus::Client).to receive(:post).and_return(double(parsed_response: mock_response))
      end

      it 'returns the parsed response with the access token' do
        token_response = client.access_token
        expect(token_response).to eq(mock_response)
      end

      it 'calls the post method with the correct parameters' do
        expected_body = {
          'grant_type' => 'client_credentials',
          'client_id' => 'test_client_id',
          'client_secret' => 'test_client_secret'
        }

        client.access_token
        expect(Integrations::Amadeus::Client).to have_received(:post).with(
          '/v1/security/oauth2/token',
          hash_including(body: expected_body)
        )
      end
    end

    context 'when the API call fails' do
      let(:error_response) do
        {
          'errors' => [
            'code' => 38_192,
            'title' => 'Invalid parameters',
            'detail' => 'Invalid API key or API secret.'
          ]
        }
      end

      before do
        # Mock the HTTParty post request to return a fake error
        allow(Integrations::Amadeus::Client).to receive(:post).and_return(double(parsed_response: error_response))
      end

      it 'returns the parsed error response' do
        token_response = client.access_token
        expect(token_response).to eq(error_response)
      end
    end
  end
end
