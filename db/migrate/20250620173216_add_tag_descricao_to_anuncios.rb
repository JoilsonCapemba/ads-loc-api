class AddTagDescricaoToAnuncios < ActiveRecord::Migration[8.0]
  def change
    add_column :anuncios, :tag_descricao, :string
  end
end
