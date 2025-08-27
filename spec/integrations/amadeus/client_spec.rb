# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integrations::Amadeus::Client do
  let(:params) do
    {
      origin: 'NYC',
      destination: 'LAX',
      departure_date: '2024-12-01',
      adults: 2
    }
  end

  let(:client) { described_class.new(params) }
  let(:mock_search_response) { { 'data' => [], 'meta' => {} } }
  let(:flight_offers_searcher) { instance_double(Integrations::Amadeus::FlightOffersSearcher) }

  describe '#initialize' do
    it 'initializes with params' do
      expect(client.instance_variable_get(:@params)).to eq(params)
    end

    it 'initializes with empty params when none provided' do
      empty_client = described_class.new
      expect(empty_client.instance_variable_get(:@params)).to eq({})
    end

    it 'initializes with specific params' do
      custom_params = { origin: 'JFK', destination: 'SFO' }
      custom_client = described_class.new(custom_params)
      expect(custom_client.instance_variable_get(:@params)).to eq(custom_params)
    end
  end

  describe '#search_flights' do
    before do
      allow(Integrations::Amadeus::FlightOffersSearcher).to receive(:new)
        .with(params)
        .and_return(flight_offers_searcher)
      allow(flight_offers_searcher).to receive(:search).and_return(mock_search_response)
    end

    it 'creates a new FlightOffersSearcher instance with params' do
      expect(Integrations::Amadeus::FlightOffersSearcher).to receive(:new).with(params)
      client.search_flights
    end

    it 'calls search on the FlightOffersSearcher instance' do
      expect(flight_offers_searcher).to receive(:search)
      client.search_flights
    end

    it 'returns the result from FlightOffersSearcher#search' do
      result = client.search_flights
      expect(result).to eq(mock_search_response)
    end

    context 'with different response types' do
      let(:error_response) { { 'errors' => [{ 'code' => 400, 'title' => 'Bad Request' }] } }

      it 'returns successful response' do
        result = client.search_flights
        expect(result).to eq(mock_search_response)
      end

      it 'returns error response when searcher returns error' do
        allow(flight_offers_searcher).to receive(:search).and_return(error_response)
        result = client.search_flights
        expect(result).to eq(error_response)
      end
    end

    context 'when FlightOffersSearcher raises an error' do
      before do
        allow(flight_offers_searcher).to receive(:search).and_raise(StandardError.new('API Error'))
      end

      it 'raises the same error' do
        expect do
          client.search_flights
        end.to raise_error(StandardError, 'API Error')
      end
    end

    context 'with empty params' do
      let(:empty_client) { described_class.new }
      let(:empty_searcher) { instance_double(Integrations::Amadeus::FlightOffersSearcher) }

      before do
        allow(Integrations::Amadeus::FlightOffersSearcher).to receive(:new)
          .with({})
          .and_return(empty_searcher)
        allow(empty_searcher).to receive(:search).and_return(mock_search_response)
      end

      it 'creates searcher with empty params' do
        expect(Integrations::Amadeus::FlightOffersSearcher).to receive(:new).with({})
        empty_client.search_flights
      end
    end
  end

  describe 'interface consistency' do
    it 'responds to search_flights method' do
      expect(client).to respond_to(:search_flights)
    end

    it 'has a simple public interface' do
      public_methods = described_class.public_instance_methods(false)
      expect(public_methods).to contain_exactly(:search_flights)
    end
  end
end
