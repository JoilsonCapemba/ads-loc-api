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
      begin
        # Tentar gerar URL completa
        Rails.application.routes.url_helpers.url_for(fotos.first)
      rescue ArgumentError => e
        # Se falhar por falta de host, retornar URL relativa
        if e.message.include?("Missing host")
          Rails.application.routes.url_helpers.rails_blob_path(fotos.first, only_path: true)
        else
          raise e
        end
      end
    else
      nil
    end
  end
end
