class AddItemsTable < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :content, null: false
      t.timestamp :review_at, null: false
      t.integer :answer_type, null: false
      t.integer :user_id
    end

    add_index :questions, :user_id, unique: true

    create_table :answers do |t|
      t.text :content, null: false
    end
  end
end
