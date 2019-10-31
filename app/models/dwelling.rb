class Dwelling < ApplicationRecord
  belongs_to :development
  belongs_to :registered_provider, optional: true

  audited(
    associated_with: :development,
    if: :audit_changes?,
    on: %i[create update destroy],
    comment_required: true,
    except: %i[address registered_provider_id]
  )

  TENURES = %w[open social intermediate].freeze

  scope :within_s106, -> { where(tenure: %w[social intermediate]) }

  validates :tenure, presence: true
  validates :habitable_rooms, presence: true
  validates :bedrooms, presence: true

  delegate :audit_changes?, to: :development

  private

  def comment_required_state?
    # Monkey patch explanation:
    # The Audited gem doesn't create a changelog if there are no audited_changes
    # eg in the situation where we're only changing `address`, and address is
    # ignored by audited. So in this situation, we shouldn't require a comment
    # either.
    # TODO: Make this a PR on the audited gem itself
    super && audited_changes.present?
  end
end
