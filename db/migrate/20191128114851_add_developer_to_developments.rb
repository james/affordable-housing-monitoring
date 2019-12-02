class AddDeveloperToDevelopments < ActiveRecord::Migration[6.0]
  def change
    add_column :developments, :developer, :string
  end
end
