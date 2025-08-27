# frozen_string_literal: true

module Integrations
  module Amadeus
    # Client to interact with the Amadeus API
    class Client
      include HTTParty
      base_uri 'https://test.api.amadeus.com'
      attr_reader :client_id, :client_secret

      def initialize
        @client_id = ENV['AMADEUS_CLIENT_ID']
        @client_secret = ENV['AMADEUS_CLIENT_SECRET']
      end

      def access_token
        options = {
          headers: headers,
          body: body
        }
        response = self.class.post('/v1/security/oauth2/token', options)
        response.parsed_response
      end

      private

      def headers
        {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      end

      def body
        {
          'grant_type' => 'client_credentials',
          'client_id' => client_id,
          'client_secret' => client_secret
        }
      end
    end
  end
end
