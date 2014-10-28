class AddItemsTable < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :content, null: false
      t.timestamp :review_at, null: false
      t.integer :type, null: false
    end

    create_table :answers do |t|
      t.text :content, null: false
    end
  end
end
