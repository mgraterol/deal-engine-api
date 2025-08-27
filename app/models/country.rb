class Country < ApplicationRecord
  has_many :airports, dependent: :destroy
end
