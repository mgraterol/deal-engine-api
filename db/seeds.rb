# --- Countries ---
puts 'Creating countries...'
countries = Country.create!([
                              { name: 'United States', code: 'US' },
                              { name: 'United Kingdom', code: 'UK' },
                              { name: 'France', code: 'FR' },
                              { name: 'Germany', code: 'DE' },
                              { name: 'Japan', code: 'JP' }
                            ])
puts 'Countries created successfully!'

# --- Airports ---
puts 'Creating airports...'

us = countries.find { |c| c.code == 'US' }
uk = countries.find { |c| c.code == 'UK' }
fr = countries.find { |c| c.code == 'FR' }
de = countries.find { |c| c.code == 'DE' }
jp = countries.find { |c| c.code == 'JP' }

Airport.create!([
                  # United States
                  { name: 'John F. Kennedy International Airport', city: 'New York', code: 'JFK', country: us },
                  { name: 'Los Angeles International Airport', city: 'Los Angeles', code: 'LAX', country: us },
                  { name: 'O\'Hare International Airport', city: 'Chicago', code: 'ORD', country: us },
                  { name: 'San Francisco International Airport', city: 'San Francisco', code: 'SFO', country: us },
                  { name: 'Miami International Airport', city: 'Miami', code: 'MIA', country: us },

                  # United Kingdom
                  { name: 'London Heathrow Airport', city: 'London', code: 'LHR', country: uk },
                  { name: 'Gatwick Airport', city: 'London', code: 'LGW', country: uk },
                  { name: 'Manchester Airport', city: 'Manchester', code: 'MAN', country: uk },
                  { name: 'Edinburgh Airport', city: 'Edinburgh', code: 'EDI', country: uk },

                  # France
                  { name: 'Charles de Gaulle Airport', city: 'Paris', code: 'CDG', country: fr },
                  { name: 'Orly Airport', city: 'Paris', code: 'ORY', country: fr },
                  { name: 'Nice Côte d\'Azur Airport', city: 'Nice', code: 'NCE', country: fr },
                  { name: 'Lyon–Saint-Exupéry Airport', city: 'Lyon', code: 'LYS', country: fr },

                  # Germany
                  { name: 'Frankfurt Airport', city: 'Frankfurt', code: 'FRA', country: de },
                  { name: 'Munich Airport', city: 'Munich', code: 'MUC', country: de },
                  { name: 'Berlin Brandenburg Airport', city: 'Berlin', code: 'BER', country: de },
                  { name: 'Düsseldorf Airport', city: 'Dusseldorf', code: 'DUS', country: de },

                  # Japan
                  { name: 'Haneda Airport', city: 'Tokyo', code: 'HND', country: jp },
                  { name: 'Narita International Airport', city: 'Tokyo', code: 'NRT', country: jp },
                  { name: 'Kansai International Airport', city: 'Osaka', code: 'KIX', country: jp },
                  { name: 'Fukuoka Airport', city: 'Fukuoka', code: 'FUK', country: jp }
                ])
puts 'Airports created successfully!'
