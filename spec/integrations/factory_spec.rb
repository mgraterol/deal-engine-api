# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integrations::Factory do
  describe '.create' do
    context 'when the API is supported' do
      it 'returns an instance of the Amadeus::Client' do
        client = described_class.create('amadeus')
        expect(client).to be_an_instance_of(Integrations::Amadeus::Client)
      end
    end

    context 'when the API is not supported' do
      it 'raises an ArgumentError' do
        expect { described_class.create('unsupported_api') }.to raise_error(
          ArgumentError,
          "Trip API 'unsupported_api' not supported."
        )
      end
    end
  end
end
