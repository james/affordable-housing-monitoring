class AddNameToDevelopments < ActiveRecord::Migration[6.0]
  def change
    add_column :developments, :name, :string
  end
end
