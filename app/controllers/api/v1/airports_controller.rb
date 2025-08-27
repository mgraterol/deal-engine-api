# frozen_string_literal: true

# Airports controller
class Api::V1::AirportsController < ApplicationController
  def index
    country_code = params[:country]&.upcase
    if country_code.present?
      country = Country.find_by(code: country_code)
      if country
        airports = country.airports.select(:code, :name, :city) # Select specific attributes
        render json: airports, status: :ok
      else
        render json: { error: "Country with code '#{country_code}' not found." }, status: :not_found
      end
    else
      render json: { error: 'Country code is required.' }, status: :bad_request
    end
  end
end
