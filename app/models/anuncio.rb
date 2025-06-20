class Anuncio < ApplicationRecord
  belongs_to :local
  belongs_to :user
  has_many_attached :fotos

  def local_nome
    local.try(:nome)
  end

  def user_nome
    user.try(:nome) || user.try(:username) || "Usuário"
  end

  def fotos_url
    if fotos.attached?
      Rails.application.routes.url_helpers.url_for(fotos.first)
    else
      nil
    end
  end
end
