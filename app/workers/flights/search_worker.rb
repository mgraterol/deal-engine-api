# frozen_string_literal: true

module Flights
  class SearchWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(job_id, params)
      search_service = Flights::Search.new('amadeus', params.symbolize_keys)

      # Use a variable to hold the final payload
      final_payload = nil

      begin
        # Attempt to call the search service
        response = search_service.call

        # If successful, prepare the response payload
        final_payload = response
      rescue StandardError => e
        # If an error occurs, prepare an error payload
        final_payload = { errors: e.message }
      ensure
        # The 'ensure' block always runs, regardless of success or failure.
        # This is where we ensure the broadcast happens every time.
        ActionCable.server.broadcast("flights_#{job_id}", final_payload)
      end
    end
  end
end
