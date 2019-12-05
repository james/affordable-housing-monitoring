class CreateSchemes < ActiveRecord::Migration[6.0]
  def change
    create_table :schemes do |t|
      t.string :name
      t.string :application_number
      t.string :site_address
      t.text :proposal
      t.string :developer

      t.timestamps
    end
  end
end
