class PlanningApplication < ApplicationRecord
  belongs_to :development
  validates :application_number, presence: true
end
