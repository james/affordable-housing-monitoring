class CreatePlanningApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :planning_applications do |t|
      t.string :application_number
      t.references :development, null: false, foreign_key: true

      t.timestamps
    end
  end
end
