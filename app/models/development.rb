class Development < ApplicationRecord
  belongs_to :scheme, optional: true
  has_many :planning_applications, dependent: :destroy
  accepts_nested_attributes_for :planning_applications
  has_many :dwellings, dependent: :delete_all
  accepts_nested_attributes_for :dwellings, update_only: true

  validates :planning_applications, presence: true
  validates :state, presence: true
  validates :developer_access_key, presence: true
  validates :rp_access_key, presence: true

  before_validation :set_developer_access_key, on: :create
  before_validation :set_rp_access_key, on: :create

  acts_as_gov_uk_date :agreed_on, :started_on

  audited(
    if: :audit_changes?,
    on: [:update],
    comment_required: true,
    except: %i[state agreed_on started_on scheme_id]
  )
  attr_accessor :audit_planning_application_id

  include AASM
  aasm column: 'state' do
    state :draft, initial: true
    state :agreed, :started, :unconfirmed_completed, :partially_confirmed_completed, :confirmed_completed

    event :agree do
      transitions from: :draft, to: :agreed
    end

    event :start do
      transitions from: :agreed, to: :started
    end

    event :unconfirmed_complete do
      transitions from: :started, to: :unconfirmed_completed
    end

    event :partially_confirmed_complete do
      transitions from: :unconfirmed_completed, to: :partially_confirmed_completed
    end

    event :confirmed_complete do
      transitions from: :partially_confirmed_completed, to: :confirmed_completed
    end
  end

  include PgSearch::Model
  pg_search_scope :search,
                  against: %i[proposal site_address developer],
                  associated_against: {
                    dwellings: [:address],
                    planning_applications: [:application_number],
                  }

  def audit_changes?
    state != 'draft'
  end

  def completion_response_needed?
    return false if state != 'unconfirmed_completed'

    !completion_response_filled?
  end

  def completion_response_filled?
    return false if state != 'unconfirmed_completed'

    dwellings.within_s106.find { |dwelling| dwelling.address.blank? || dwelling.registered_provider.blank? }.blank?
  end

  def primary_application_number
    planning_applications.first.application_number
  end

  def completed?
    unconfirmed_completed? || partially_confirmed_completed? || confirmed_completed?
  end

  private

  def set_developer_access_key
    self.developer_access_key = SecureRandom.urlsafe_base64(20)
  end

  def set_rp_access_key
    self.rp_access_key = SecureRandom.urlsafe_base64(20)
  end

  def write_audit(attrs)
    attrs[:planning_application_id] = audit_planning_application_id if audit_planning_application_id.present?
    super
  end
end
