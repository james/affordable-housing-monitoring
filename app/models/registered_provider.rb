class RegisteredProvider < ApplicationRecord
  has_many :dwellings, dependent: :nullify
end
