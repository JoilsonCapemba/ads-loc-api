class User < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :perfils
  belongs_to :local, optional: true
  has_one_attached :avatar

  # Validações
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3 }
  validates :full_name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  
  # callback para definir o saldo inicial do usuario assim que criamos o user
  before_create :set_saldo_padrao

  def avatar_url
    if avatar.attached?
      begin
        # Gerar URL completa com o host configurado
        Rails.application.routes.url_helpers.url_for(avatar)
      rescue ArgumentError => e
        # Se falhar, tentar com configuração explícita
        if e.message.include?("Missing host")
          Rails.application.routes.url_helpers.rails_blob_url(avatar, host: "192.168.1.8:3000")
        else
          raise e
        end
      end
    else
      nil
    end
  end

  private

  def set_saldo_padrao
    self.saldo ||= 10.0
  end
end
