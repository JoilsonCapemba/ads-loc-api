class CreateJoinTableUsersPerfils < ActiveRecord::Migration[8.0]
  def change
    create_join_table :users, :perfils do |t|
      t.index [ :user_id, :perfil_id ]
      t.index [ :perfil_id, :user_id ]
    end
  end
end
