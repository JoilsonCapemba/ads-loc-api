class CreateCoordenadas < ActiveRecord::Migration[8.0]
  def change
    create_table :coordenadas do |t|
      t.float :latitude
      t.float :longitude
      t.float :raio

      t.timestamps
    end
  end
end
