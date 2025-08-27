# frozen_string_literal: true

module Integrations
  module Amadeus
    class SearchBodyBuilder
      def initialize(search_params)
        @search_params = search_params.transform_values { |v| v.presence }
      end

      def build
        body = {
          'currencyCode' => @search_params[:currency],
          'originDestinations' => build_origin_destinations,
          'travelers' => [{ 'id' => '1', 'travelerType' => 'ADULT' }],
          'sources' => ['GDS']
        }

        # Remove keys with nil values before returning
        body.compact
      end

      private

      def build_origin_destinations
        destinations = []

        # Add the outbound flight segment if `departure_date` is present
        if @search_params[:departure_date].present?
          destinations << {
            'id' => '1',
            'originLocationCode' => @search_params[:origin],
            'destinationLocationCode' => @search_params[:destination],
            'departureDateTimeRange' => {
              'date' => @search_params[:departure_date]
            }
          }.compact
        end

        # Add the return flight segment if `return_date` is present
        if @search_params[:return_date].present?
          destinations << {
            'id' => '2',
            'originLocationCode' => @search_params[:destination],
            'destinationLocationCode' => @search_params[:origin],
            'departureDateTimeRange' => {
              'date' => @search_params[:return_date]
            }
          }.compact
        end

        destinations
      end
    end
  end
end
