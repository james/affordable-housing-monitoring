class AddAddressAndRpToDwellings < ActiveRecord::Migration[6.0]
  def change
    add_column :dwellings, :address, :string
    add_reference :dwellings, :registered_provider, foreign_key: true
  end
end
