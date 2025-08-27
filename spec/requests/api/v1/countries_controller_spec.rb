# spec/requests/api/v1/countries_controller_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::CountriesController', type: :request do
  describe 'GET /api/v1/countries' do
    # Create some countries to test with
    let!(:us) { create(:country, name: 'United States', code: 'US') }
    let!(:uk) { create(:country, name: 'United Kingdom', code: 'UK') }
    let!(:fr) { create(:country, name: 'France', code: 'FR') }

    it 'returns a successful response' do
      get '/api/v1/countries'
      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of all countries' do
      get '/api/v1/countries'
      json_response = JSON.parse(response.body)

      expect(json_response.size).to eq(3)

      country_names = json_response.map { |c| c['name'] }
      expect(country_names).to match_array(['United States', 'United Kingdom', 'France'])
    end

    it 'returns the correct attributes for each country' do
      get '/api/v1/countries'
      json_response = JSON.parse(response.body)
      us_data = json_response.find { |c| c['code'] == 'US' }

      expect(us_data).to be_present
      expect(us_data['name']).to eq('United States')
      expect(us_data['code']).to eq('US')
    end
  end
end
