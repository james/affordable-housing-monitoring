class AddAgreedOnToDevelopments < ActiveRecord::Migration[6.0]
  def change
    add_column :developments, :agreed_on, :date
  end
end
