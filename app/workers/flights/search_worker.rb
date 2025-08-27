# frozen_string_literal: true

module Flights
  class SearchWorker
    include Sidekiq::Worker

    def perform(job_id, params)
      search_service = Flights::Search.new('amadeus', params.symbolize_keys)

      begin
        response = search_service.call

        ActionCable.server.broadcast("flights_#{job_id}", response)
      rescue StandardError => e
        ActionCable.server.broadcast("flights_#{job_id}", { errors: e.message })
      end
    end
  end
end
