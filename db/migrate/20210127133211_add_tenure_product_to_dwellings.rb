class AddTenureProductToDwellings < ActiveRecord::Migration[6.0]
  def change
    add_column :dwellings, :tenure_product, :string
  end
end
