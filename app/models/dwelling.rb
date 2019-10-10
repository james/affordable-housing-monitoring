class Dwelling < ApplicationRecord
  belongs_to :development

  TENURES = %w[open social intermediate].freeze

  validates :tenure, presence: true
  validates :habitable_rooms, presence: true
  validates :bedrooms, presence: true
end
