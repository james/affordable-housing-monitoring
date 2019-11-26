class AddPlanningApplicationToAudits < ActiveRecord::Migration[6.0]
  def change
    add_reference :audits, :planning_application, foreign_key: true
  end
end
