FactoryBot.define do
  factory :airport do
    association :country # This creates and associates a country
    name { Faker::Address.city + ' Airport' }
    city { Faker::Address.city }
    code { Faker::Travel::Airport.iata }
  end
end
