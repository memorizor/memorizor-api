class AddCatagoriesTable < ActiveRecord::Migration
  def change
    create_table :catagories do |t|
      t.string :name, null: false
      t.string :color, null: false
      t.integer :user_id, null: false
    end

    add_index :catagories, :user_id

    create_table :catagories_questions, id: false do |t|
      t.integer :catagory_id, null: false
      t.integer :question_id, null: false
    end
  end
end
