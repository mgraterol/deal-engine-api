# frozen_string_literal: true

module Integrations
  # Factory to create travel API clients
  class Factory
    def self.create(api_name)
      case api_name.to_s.downcase
      when 'amadeus'
        Integrations::Amadeus::Client.new
      else
        raise ArgumentError, "Trip API '#{api_name}' not supported."
      end
    end
  end
end
