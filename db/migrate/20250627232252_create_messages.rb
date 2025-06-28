class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.text :content
      t.boolean :read, default: false

      t.timestamps
    end
    
    # Índice para melhorar performance de consultas
    add_index :messages, [:chat_id, :created_at]
    add_index :messages, [:sender_id, :read]
  end
end
