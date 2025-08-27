# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integrations::Amadeus::FlightOffersSearcher do
  let(:params) do
    {
      origin: 'NYC',
      destination: 'LAX',
      departure_date: '2024-12-01',
      adults: 2,
      currency: 'USD'
    }
  end

  let(:searcher) { described_class.new(params) }
  let(:mock_auth_response) { { 'access_token' => 'fake_token_123' } }
  let(:mock_success_response) { double(success?: true, body: '{"data": []}') }
  let(:mock_error_response) { double(success?: false, body: '{"errors": [{"title": "Error", "detail": "Details"}]}') }
  let(:mock_auth_instance) { instance_double(Integrations::Amadeus::Auth) }
  let(:mock_search_body) { { flightOffers: [] } }
  let(:mock_builder_instance) { instance_double(Integrations::Amadeus::SearchBodyBuilder) }

  before do
    # Mock Auth
    allow(Integrations::Amadeus::Auth).to receive(:new).and_return(mock_auth_instance)
    allow(mock_auth_instance).to receive(:access_token).and_return(mock_auth_response)

    # Mock SearchBodyBuilder
    allow(Integrations::Amadeus::SearchBodyBuilder).to receive(:new)
      .with(params)
      .and_return(mock_builder_instance)
    allow(mock_builder_instance).to receive(:build).and_return(mock_search_body)
  end

  describe '#initialize' do
    it 'initializes with params' do
      expect(searcher.instance_variable_get(:@params)).to eq(params)
    end
  end

  describe '#search' do
    context 'when API call is successful' do
      before do
        allow(described_class).to receive(:post).and_return(mock_success_response)
      end

      it 'calls the Amadeus API with correct endpoint' do
        expect(described_class).to receive(:post).with('/v2/shopping/flight-offers', anything)
        searcher.search
      end

      it 'includes proper headers with authorization token' do
        expect(described_class).to receive(:post).with(
          anything,
          hash_including(
            headers: hash_including(
              'Authorization' => 'Bearer fake_token_123',
              'Content-Type' => 'application/json'
            )
          )
        )
        searcher.search
      end

      it 'includes JSON body from SearchBodyBuilder' do
        expect(described_class).to receive(:post).with(
          anything,
          hash_including(body: mock_search_body.to_json)
        )
        searcher.search
      end

      it 'returns parsed JSON response' do
        result = searcher.search
        expect(result).to eq({ 'data' => [] })
      end

      it 'creates Auth instance to get access token' do
        expect(Integrations::Amadeus::Auth).to receive(:new)
        expect(mock_auth_instance).to receive(:access_token)
        searcher.search
      end

      it 'creates SearchBodyBuilder with params' do
        expect(Integrations::Amadeus::SearchBodyBuilder).to receive(:new).with(params)
        searcher.search
      end
    end

    context 'when API call fails' do
      before do
        allow(described_class).to receive(:post).and_return(mock_error_response)
      end

      it 'raises an error with API error details' do
        expect do
          searcher.search
        end.to raise_error(RuntimeError, 'API call failed: Error Details')
      end
    end

    context 'when authentication fails' do
      before do
        allow(mock_auth_instance).to receive(:access_token).and_return({})
      end

      it 'raises authentication error' do
        expect do
          searcher.search
        end.to raise_error('Authentication failed: No access token received.')
      end
    end

    context 'when authentication returns nil access token' do
      before do
        allow(mock_auth_instance).to receive(:access_token).and_return({ 'access_token' => nil })
      end

      it 'raises authentication error' do
        expect do
          searcher.search
        end.to raise_error('Authentication failed: No access token received.')
      end
    end

    context 'when authentication returns error response' do
      before do
        allow(mock_auth_instance).to receive(:access_token).and_return({ 'error' => 'invalid_client' })
      end

      it 'raises authentication error' do
        expect do
          searcher.search
        end.to raise_error('Authentication failed: No access token received.')
      end
    end

    context 'when HTTP request fails' do
      before do
        allow(described_class).to receive(:post).and_raise(Net::ReadTimeout.new)
      end

      it 'raises the network error' do
        expect { searcher.search }.to raise_error(Net::ReadTimeout)
      end
    end

    context 'when JSON parsing fails' do
      before do
        allow(described_class).to receive(:post).and_return(mock_success_response)
        allow(JSON).to receive(:parse).and_raise(JSON::ParserError.new('Invalid JSON'))
      end

      it 'raises JSON parsing error' do
        expect { searcher.search }.to raise_error(JSON::ParserError)
      end
    end
  end

  describe 'private methods' do
    describe '#headers' do
      it 'returns headers with authorization token' do
        headers = searcher.send(:headers)
        expect(headers).to include(
          'Authorization' => 'Bearer fake_token_123',
          'Content-Type' => 'application/json'
        )
      end

      it 'raises error when no access token' do
        allow(mock_auth_instance).to receive(:access_token).and_return({})
        expect { searcher.send(:headers) }.to raise_error('Authentication failed: No access token received.')
      end
    end

    describe '#body' do
      it 'delegates to SearchBodyBuilder with params' do
        expect(Integrations::Amadeus::SearchBodyBuilder).to receive(:new).with(params)
        expect(mock_builder_instance).to receive(:build)
        searcher.send(:body)
      end

      it 'returns the built search body' do
        result = searcher.send(:body)
        expect(result).to eq(mock_search_body)
      end
    end
  end

  describe 'HTTParty configuration' do
    it 'has correct base URI' do
      expect(described_class.base_uri).to eq('https://test.api.amadeus.com')
    end

    it 'includes HTTParty module' do
      expect(described_class.included_modules).to include(HTTParty)
    end
  end
end
