class MakeDevelopmentOptionalForDwelling < ActiveRecord::Migration[6.0]
  def change
    change_column :dwellings, :development_id, :bigint, :null => true
  end
end
