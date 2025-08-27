module Flights
  class EnqueSearch
    def initialize(flight_params)
      @flight_params = flight_params
    end

    def call
      job_id = SecureRandom.uuid
      flight = Flight.new(@flight_params).attributes.compact!
      Flights::SearchWorker.perform_async(job_id, flight)
      { job_id: job_id, status: 'accepted' }
    end
  end
end
