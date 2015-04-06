class AddItemsTable < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :content, null: false
      t.timestamp :review_at, null: false
      t.integer :answer_type, null: false
      t.integer :user_id, null: false
      t.integer :level, null: false, default: 1
    end

    add_index :questions, :user_id

    create_table :answers do |t|
      t.text :content, null: false
      t.integer :question_id, null: false
    end

    add_index :answers, :question_id
  end
end
