# frozen_string_literal: true

# Flight search controller
class Api::V1::FlightsController < ApplicationController
  def index
    response = Flights::Search.new('amadeus', flight_params).call
    render json: response, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :bad_request
  end

  private

  def flight_params
    params.require(:flight).permit(:origin, :destination, :departure_date, :return_date, :adults, :currency)
  end
end
