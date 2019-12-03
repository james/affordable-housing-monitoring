class AddStartedOnToDevelopments < ActiveRecord::Migration[6.0]
  def change
    add_column :developments, :started_on, :date
  end
end
