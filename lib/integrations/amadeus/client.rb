# frozen_string_literal: true

module Integrations
  module Amadeus
    # Client to interact with the Amadeus API
    class Client
      def initialize(params = {})
        @params = params
      end

      def search_flights
        Integrations::Amadeus::FlightOffersSearcher.new(@params).search
      end
    end
  end
end
