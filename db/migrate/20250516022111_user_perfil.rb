class UserPerfil < ActiveRecord::Migration[8.0]
  def change
    create_table :users_perfils do |t|
      t.belongs_to :user
    
      t.belongs_to :Perfil
    end
    
  end
end
