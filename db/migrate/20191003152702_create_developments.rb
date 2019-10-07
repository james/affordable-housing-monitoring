class CreateDevelopments < ActiveRecord::Migration[6.0]
  def change
    create_table :developments do |t|
      t.string :application_number
      t.string :site_address
      t.text :proposal

      t.timestamps
    end
  end
end
