# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integrations::Amadeus::Auth do # rubocop:disable Metrics/BlockLength
  subject(:client) { described_class.new }

  # Use let to define mock ENV variables
  let(:amadeus_client_id) { 'test_client_id' }
  let(:amadeus_client_secret) { 'test_client_secret' }

  # Mock ENV variables for each test
  before do
    allow(ENV).to receive(:[]).with('AMADEUS_CLIENT_ID').and_return(amadeus_client_id)
    allow(ENV).to receive(:[]).with('AMADEUS_CLIENT_SECRET').and_return(amadeus_client_secret)
  end

  describe '#access_token' do
    # Add the missing mock_response variable
    let(:mock_response) { { 'access_token' => 'a_valid_access_token' } }

    context 'when the API call is successful' do
      let(:amadeus_credentials) do
        {
          client_id: 'test_client_id',
          client_secret: 'test_client_secret'
        }
      end

      before do
        # Mock the credentials call
        allow(Rails.application.credentials).to receive(:amadeus).and_return(amadeus_credentials)

        # Now mock the HTTParty post call
        # mock_response is now defined and available
        allow(described_class).to receive(:post).and_return(double(parsed_response: mock_response))
      end

      it 'calls the post method with the correct parameters' do
        expected_body = {
          'grant_type' => 'client_credentials',
          'client_id' => amadeus_credentials[:client_id],
          'client_secret' => amadeus_credentials[:client_secret]
        }

        expect(described_class).to receive(:post).with(
          '/v1/security/oauth2/token',
          hash_including(body: expected_body)
        )
        client.access_token
      end
    end
  end
end
