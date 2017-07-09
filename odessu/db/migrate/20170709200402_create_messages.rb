class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    drop_table :messages
    create_table :messages do |t|
      t.text :body
      t.integer :conversation_id
      t.integer :author_id
      t.integer :receiver_id

      t.timestamps
    end
    add_index :messages, :conversation_id
    add_index :messages, :author_id
    add_index :messages, :receiver_id
  end
end
