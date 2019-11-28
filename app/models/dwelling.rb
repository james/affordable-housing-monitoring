class Dwelling < ApplicationRecord
  belongs_to :development
  belongs_to :registered_provider, optional: true

  audited(
    associated_with: :development,
    if: :audit_changes?,
    on: %i[create update destroy],
    comment_required: true,
    except: %i[address registered_provider_id rp_internal_id]
  )

  attr_accessor :audit_planning_application_id

  TENURES = %w[open social intermediate].freeze

  scope :within_s106, -> { where(tenure: %w[social intermediate]) }

  validates :tenure, presence: true
  validates :habitable_rooms, presence: true
  validates :bedrooms, presence: true
  validates :reference_id, presence: true, uniqueness: { scope: :development }

  delegate :audit_changes?, to: :development

  private

  def write_audit(attrs)
    attrs[:planning_application_id] = audit_planning_application_id if audit_planning_application_id.present?
    super
  end
end
