# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flights::Search do
  let(:api_name) { :amadeus }
  let(:search_params) do
    {
      origin: 'NYC',
      destination: 'LAX',
      departure_date: '2024-12-01',
      adults: 2
    }
  end

  let(:flight_search) { described_class.new(api_name, search_params) }
  let(:mock_api_client) { instance_double(Integrations::Amadeus::Client) }
  let(:mock_search_response) { { 'data' => [{ 'flight': 'details' }] } }

  describe '#initialize' do
    it 'initializes with api_name and search_params' do
      expect(flight_search.instance_variable_get(:@api_name)).to eq(api_name)
      expect(flight_search.instance_variable_get(:@search_params)).to eq(search_params)
    end

    it 'exposes search_params via attr_reader' do
      expect(flight_search.search_params).to eq(search_params)
    end
  end

  describe '#call' do
    # This before block is now more flexible, accepting any arguments for :create
    before do
      allow(Integrations::Factory).to receive(:create).and_return(mock_api_client)
      # You must also stub the method on the returned mock_api_client
      allow(mock_api_client).to receive(:search_flights).and_return(mock_search_response)
    end

    context 'when API client returns successful response' do
      it 'creates API client using the factory' do
        expect(Integrations::Factory).to receive(:create).with(api_name, search_params)
        flight_search.call
      end

      it 'calls search_flights on the API client' do
        expect(mock_api_client).to receive(:search_flights)
        flight_search.call
      end

      it 'returns the search response' do
        result = flight_search.call
        expect(result).to eq(mock_search_response)
      end

      it 'does not raise an error' do
        expect { flight_search.call }.not_to raise_error
      end
    end

    context 'with different search parameters' do
      let(:different_params) do
        {
          origin: 'JFK',
          destination: 'SFO',
          departure_date: '2024-11-15',
          adults: 1
        }
      end

      it 'uses the correct search parameters in factory' do
        different_search = described_class.new(api_name, different_params)

        # The mock is already set, so we can verify the call here
        expect(Integrations::Factory).to receive(:create).with(api_name, different_params)
        different_search.call
      end
    end
  end

  describe 'error handling robustness' do
    # Mock the factory for any parameters to prevent `nil` errors
    before do
      allow(Integrations::Factory).to receive(:create).and_return(mock_api_client)
    end

    context 'when API client returns nil' do
      before do
        allow(mock_api_client).to receive(:search_flights).and_return(nil)
      end

      it 'returns nil without raising error' do
        result = flight_search.call
        expect(result).to be_nil
      end
    end

    context 'when API client returns empty response' do
      before do
        allow(mock_api_client).to receive(:search_flights).and_return({})
      end

      it 'returns the empty response' do
        result = flight_search.call
        expect(result).to eq({})
      end
    end
  end
end
