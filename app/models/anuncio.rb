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
        # Gerar URL completa com o host configurado
        Rails.application.routes.url_helpers.url_for(fotos.first)
      rescue ArgumentError => e
        # Se falhar, tentar com configuração explícita
        if e.message.include?("Missing host")
          Rails.application.routes.url_helpers.rails_blob_url(fotos.first, host: "192.168.1.8:3000")
        else
          raise e
        end
      end
    else
      nil
    end
  end
end
