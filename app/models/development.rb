class Development < ApplicationRecord
  has_many :dwellings, dependent: :destroy
end
