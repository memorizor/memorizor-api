class AddItemsTable < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.text :question, null: false
      t.text :answer, null: false
      t.timestamp :review_at, null: false
    end
  end
end
