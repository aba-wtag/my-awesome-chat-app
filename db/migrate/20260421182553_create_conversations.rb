class CreateConversations < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.boolean :is_group
      t.string :name
      t.string :unique_key

      t.timestamps
    end
    add_index :conversations, :unique_key
  end
end
