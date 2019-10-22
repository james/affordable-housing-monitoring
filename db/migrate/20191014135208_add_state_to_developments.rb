class AddStateToDevelopments < ActiveRecord::Migration[6.0]
  def change
    add_column :developments, :state, :string, null: false, default: 'draft'
  end
end
