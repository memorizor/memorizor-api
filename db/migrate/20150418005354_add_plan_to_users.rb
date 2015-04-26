class AddPlanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :plan, :integer, default: 1
    add_column :users, :stripe_id, :string, unique: true
    add_column :users, :stripe_plan, :string, unique: true

    add_index :users, :stripe_id
  end
end
