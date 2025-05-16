class CreateLocals < ActiveRecord::Migration[8.0]
  def change
    create_table :locals do |t|
      t.string :nome
      t.references :coordenada, null: false, foreign_key: true

      t.timestamps
    end
  end
end
