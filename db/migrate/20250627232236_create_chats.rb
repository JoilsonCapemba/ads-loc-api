class CreateChats < ActiveRecord::Migration[8.0]
  def change
    create_table :chats do |t|
      t.references :user1, null: false, foreign_key: { to_table: :users }
      t.references :user2, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    
    # Índice único para evitar chats duplicados
    add_index :chats, [:user1_id, :user2_id], unique: true
  end
end
