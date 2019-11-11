class AddReferenceIdToDwellings < ActiveRecord::Migration[6.0]
  def change
    add_column :dwellings, :reference_id, :string
  end
end
