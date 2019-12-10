class PlanningApplication < ApplicationRecord
  belongs_to :development
  validates :application_number, presence: true

  has_many :affordable_housing_audits, dependent: :nullify
end
