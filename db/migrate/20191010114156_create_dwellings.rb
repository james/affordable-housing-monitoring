class CreateDwellings < ActiveRecord::Migration[6.0]
  def change
    create_table :dwellings do |t|
      t.string :tenure
      t.integer :habitable_rooms
      t.integer :bedrooms
      t.references :development, null: false, foreign_key: true

      t.timestamps
    end
  end
end
