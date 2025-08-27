module Flights
  class EnqueSearch
    def initialize(flight_params)
      @flight_params = flight_params
    end

    def call
      job_id = SecureRandom.uuid
      # Ensure the parameters are a standard hash with string keys before enqueuing the job
      search_params = @flight_params.deep_transform_keys(&:to_s)
      flight = Flight.new(search_params).attributes.compact!
      Flights::SearchWorker.perform_async(job_id, flight)
      { job_id: job_id, status: 'accepted' }
    end
  end
end
