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

      # The `currencyCode` key should not exist in the final hash
      expect(result).not_to have_key('currencyCode')

      # The `originLocationCode` key should not exist in the nested hash
      expect(result['originDestinations'].first).not_to have_key('originLocationCode')

      # The destination should still be there
      expect(result['originDestinations'].first['destinationLocationCode']).to eq('LAX')

      # Since `return_date` is nil, there should only be one destination in the array
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

      # Since all parameters are empty, the `originDestinations` array should be empty
      expect(result['originDestinations']).to be_empty
      # The `currencyCode` key should not be present in the final hash
      expect(result).not_to have_key('currencyCode')
    end
  end

  # ... (other test contexts remain the same)
end
