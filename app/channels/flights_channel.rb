# app/channels/flights_channel.rb

# frozen_string_literal: true

class FlightsChannel < ApplicationCable::Channel
  def subscribed
    # The client will pass the unique job_id to subscribe to a specific stream
    stream_from "flights_#{params[:job_id]}"
  end
end
