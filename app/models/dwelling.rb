class Dwelling < ApplicationRecord
  belongs_to :development, optional: true
  belongs_to :registered_provider, optional: true

  audited(
    associated_with: :development,
    if: :audit_changes?,
    on: %i[create update destroy],
    comment_required: true,
    except: %i[address uprn registered_provider_id rp_internal_id tenure_product]
  )

  attr_accessor :audit_planning_application_id

  TENURES = %w[open social intermediate].freeze
  TENURE_PRODUCTS = [
    'Social rent',
    'Shared ownership',
    'Shared equity',
    'London Living Rent',
    'Community Land Trust',
    'Discounted market sale',
    'Starter Home',
    'Affordable rent',
    'Discount market rent',
    'London Affordable Rent',
    'Build to rent'
  ].freeze

  scope :within_s106, -> { where(tenure: %w[social intermediate]) }
  default_scope -> { where('development_id IS NOT NULL') }

  validates :tenure, presence: true
  validates :habitable_rooms, presence: true, if: :development
  validates :bedrooms, presence: true, if: :development
  validates :reference_id, presence: true, uniqueness: { scope: :development }, if: :development

  private

  def audit_changes?
    if development
      development.audit_changes?
    else
      false
    end
  end

  def write_audit(attrs)
    attrs[:planning_application_id] = audit_planning_application_id if audit_planning_application_id.present?
    super
  end
end
