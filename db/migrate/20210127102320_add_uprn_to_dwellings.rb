class AddUprnToDwellings < ActiveRecord::Migration[6.0]
  def change
    add_column :dwellings, :uprn, :string
  end
end
