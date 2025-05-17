class AddLocalToUser < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :local, null: true, foreign_key: true
  end
end
