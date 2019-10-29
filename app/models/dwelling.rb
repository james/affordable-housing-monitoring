class Dwelling < ApplicationRecord
  belongs_to :development

  audited(
    associated_with: :development,
    if: :audit_changes?,
    on: %i[create update],
    comment_required: true
  )

  TENURES = %w[open social intermediate].freeze

  validates :tenure, presence: true
  validates :habitable_rooms, presence: true
  validates :bedrooms, presence: true

  delegate :audit_changes?, to: :development
end
