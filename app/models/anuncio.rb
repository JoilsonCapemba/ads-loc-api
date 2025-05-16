class Anuncio < ApplicationRecord
  belongs_to :local
  belongs_to :user
  has_many_attached :fotos
end
