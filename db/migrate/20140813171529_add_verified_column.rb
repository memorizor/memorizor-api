class AddVerifiedColumn < ActiveRecord::Migration
  def change
    change_column :users, :name, :string, null: false
    change_column :users, :email, :string, null: false
    add_column :users, :verified, :boolean, default: false
  end
end
