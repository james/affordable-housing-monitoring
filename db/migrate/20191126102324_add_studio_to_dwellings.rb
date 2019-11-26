class AddStudioToDwellings < ActiveRecord::Migration[6.0]
  def change
    add_column :dwellings, :studio, :boolean, default: false, null: false
  end
end
