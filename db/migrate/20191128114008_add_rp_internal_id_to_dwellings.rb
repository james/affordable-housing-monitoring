class AddRpInternalIdToDwellings < ActiveRecord::Migration[6.0]
  def change
    add_column :dwellings, :rp_internal_id, :string
  end
end
