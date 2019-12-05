class Scheme < ApplicationRecord
  has_many :developments, dependent: :nullify
  has_many :dwellings, through: :developments

  validates :application_number, presence: true
end
