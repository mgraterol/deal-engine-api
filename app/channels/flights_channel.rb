# app/channels/flights_channel.rb

# frozen_string_literal: true

class FlightsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "flights_#{params[:job_id]}"
  end
end
