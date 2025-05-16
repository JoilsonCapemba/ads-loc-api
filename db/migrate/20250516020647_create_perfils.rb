class CreatePerfils < ActiveRecord::Migration[8.0]
  def change
    create_table :perfils do |t|
      t.string :descricao

      t.timestamps
    end
  end
end
