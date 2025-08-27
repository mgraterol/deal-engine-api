# frozen_string_literal: true

module Flights
  class Search
    attr_reader :api_name, :search_params

    def initialize(api_name, search_params)
      @api_name = api_name
      @search_params = search_params
    end

    def call
      api_client = Integrations::Factory.create(api_name, search_params)
      api_client.search_flights
    rescue StandardError => e
      raise "Error during flight search: #{e.message}"
    end
  end
end
