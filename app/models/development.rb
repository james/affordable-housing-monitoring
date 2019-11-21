class Development < ApplicationRecord
  has_many :planning_applications, dependent: :destroy
  accepts_nested_attributes_for :planning_applications
  has_many :dwellings, dependent: :destroy
  accepts_nested_attributes_for :dwellings, update_only: true

  validates :planning_applications, presence: true
  validates :state, presence: true
  validates :developer_access_key, presence: true

  before_validation :set_developer_access_key, on: :create

  audited(
    if: :audit_changes?,
    on: [:update],
    comment_required: true,
    except: [:state]
  )

  include AASM
  aasm column: 'state' do
    state :draft, initial: true
    state :agreed, :started, :completed

    event :agree do
      transitions from: :draft, to: :agreed
    end

    event :start do
      transitions from: :agreed, to: :started
    end

    event :complete do
      transitions from: :started, to: :completed
    end
  end

  include PgSearch::Model
  pg_search_scope :search,
                  against: %i[application_number proposal site_address],
                  associated_against: {
                    dwellings: [:address],
                  }

  def audit_changes?
    state != 'draft'
  end

  def completion_response_needed?
    return false if state != 'completed'

    !completion_response_filled?
  end

  def completion_response_filled?
    return false if state != 'completed'

    dwellings.within_s106.find { |dwelling| dwelling.address.blank? || dwelling.registered_provider.blank? }.blank?
  end

  private

  def set_developer_access_key
    self.developer_access_key = SecureRandom.urlsafe_base64(20)
  end
end
