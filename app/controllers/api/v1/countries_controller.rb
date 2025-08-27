# frozen_string_literal: true

# Countries controller
class Api::V1::CountriesController < ApplicationController
  def index
    response = Country.all
    render json: response, status: :ok
  end
end
