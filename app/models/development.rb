class Development < ApplicationRecord
  has_many :dwellings, dependent: :destroy

  validates :application_number, presence: true
  validates :state, presence: true

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

  def comment_required_state?
    # Monkey patch explanation:
    # The Audited gem doesn't create a changelog if there are no audited_changes
    # eg in the situation where we're only changing `state`, and state is ignored by
    # audited. So in this situation, we shouldn't require a comment either.
    # TODO: Make this a PR on the audited gem itself
    super && audited_changes.present?
  end
end
