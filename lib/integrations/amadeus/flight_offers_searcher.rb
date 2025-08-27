# frozen_string_literal: true

module Integrations
  module Amadeus
    # Client to interact with the Amadeus API
    class FlightOffersSearcher
      include HTTParty
      base_uri 'https://test.api.amadeus.com'

      def initialize(params)
        @params = params
      end

      def search
        options = {
          headers: headers,
          body: body.to_json
        }
        response = self.class.post('/v2/shopping/flight-offers', options)

        if response.success?
          # Correct way to parse the response body
          JSON.parse(response.body)
        else
          # Correct way to parse the error body
          parsed_response = JSON.parse(response.body)
          raise "API call failed: #{parsed_response['errors'].first['title']} #{parsed_response['errors'].first['detail']}"
        end
      end

      private

      def headers
        access_token_response = Integrations::Amadeus::Auth.new.access_token
        access_token = access_token_response['access_token']

        # Raise an error if authentication fails, preventing a NoMethodError.
        raise 'Authentication failed: No access token received.' unless access_token

        {
          'Authorization' => "Bearer #{access_token}",
          'Content-Type' => 'application/json'
        }
      end

      def body
        Integrations::Amadeus::SearchBodyBuilder.new(@params).build
      end
    end
  end
end
