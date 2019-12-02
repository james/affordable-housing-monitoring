class AddRpAccessKeyToDevelopments < ActiveRecord::Migration[6.0]
  def change
    add_column :developments, :rp_access_key, :string
  end
end
