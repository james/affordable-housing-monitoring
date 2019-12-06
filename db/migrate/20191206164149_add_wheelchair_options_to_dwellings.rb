class AddWheelchairOptionsToDwellings < ActiveRecord::Migration[6.0]
  def change
    add_column :dwellings, :wheelchair_accessible, :boolean, null: false, default: false
    add_column :dwellings, :wheelchair_adaptable, :boolean, null: false, default: false
  end
end
