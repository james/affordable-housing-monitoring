class AddDeveloperAccessKeyToDevelopments < ActiveRecord::Migration[6.0]
  def change
    add_column :developments, :developer_access_key, :string
  end
end
