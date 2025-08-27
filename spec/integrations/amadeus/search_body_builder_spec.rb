# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integrations::Amadeus::SearchBodyBuilder do
  describe 'with nil parameters' do
    let(:params_with_nils) do
      {
        origin: nil,
        destination: 'LAX',
        departure_date: '2024-12-01',
        return_date: nil,
        currency: nil
      }
    end

    it 'handles nil values gracefully by omitting them' do
      builder = described_class.new(params_with_nils)
      result = builder.build
      expect(result).not_to have_key('currencyCode')
      expect(result['originDestinations'].first).not_to have_key('originLocationCode')
      expect(result['originDestinations'].first['destinationLocationCode']).to eq('LAX')
      expect(result['originDestinations'].size).to eq(1)
    end
  end

  describe 'with empty parameters' do
    let(:empty_params) do
      {
        origin: '',
        destination: '',
        departure_date: '',
        return_date: '',
        currency: ''
      }
    end

    it 'omits keys with empty string values' do
      builder = described_class.new(empty_params)
      result = builder.build
      expect(result['originDestinations']).to be_empty
      expect(result).not_to have_key('currencyCode')
    end
  end
end
