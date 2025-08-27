# spec/requests/api/v1/airports_controller_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::AirportsController', type: :request do
  # Create a couple of countries with airports to use in our tests
  let!(:us) { create(:country, code: 'US', name: 'United States') }
  let!(:uk) { create(:country, code: 'UK', name: 'United Kingdom') }

  let!(:jfk) do
    create(:airport, country: us, code: 'JFK', name: 'John F. Kennedy International Airport', city: 'New York')
  end
  let!(:lax) do
    create(:airport, country: us, code: 'LAX', name: 'Los Angeles International Airport', city: 'Los Angeles')
  end
  let!(:lhr) { create(:airport, country: uk, code: 'LHR', name: 'London Heathrow Airport', city: 'London') }

  describe 'GET /api/v1/airports' do
    context 'with a valid country code' do
      it 'returns a list of airports for that country' do
        get '/api/v1/airports', params: { country: 'US' }

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
        airport_codes = json_response.map { |a| a['code'] }
        expect(airport_codes).to include('JFK', 'LAX')
        expect(airport_codes).not_to include('LHR')
      end

      it 'returns the correct attributes for each airport' do
        get '/api/v1/airports', params: { country: 'UK' }

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response.first['code']).to eq('LHR')
        expect(json_response.first['name']).to eq('London Heathrow Airport')
        expect(json_response.first['city']).to eq('London')
      end
    end

    context 'with an invalid country code' do
      it 'returns a not found error' do
        get '/api/v1/airports', params: { country: 'XYZ' }

        expect(response).to have_http_status(:not_found)

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq("Country with code 'XYZ' not found.")
      end
    end

    context 'with no country code' do
      it 'returns a bad request error' do
        get '/api/v1/airports' # No params provided

        expect(response).to have_http_status(:bad_request)

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Country code is required.')
      end
    end
  end
end
