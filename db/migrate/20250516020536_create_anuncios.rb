class CreateAnuncios < ActiveRecord::Migration[8.0]
  def change
    create_table :anuncios do |t|
      t.string :titulo
      t.text :descricao
      t.references :local, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
