class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :sender, class_name: 'User'
  has_one_attached :attachment

  # Validações
  validates :content, presence: true, unless: :has_attachment?
  validates :sender_id, presence: true
  validates :chat_id, presence: true

  # Callbacks
  after_create :mark_as_read_for_sender

  # Scopes
  scope :unread_by, ->(user_id) { where.not(sender_id: user_id).where(read: false) }
  scope :recent, -> { order(created_at: :desc) }

  # Verificar se a mensagem tem anexo
  def has_attachment?
    attachment.attached?
  end

  # Marcar mensagem como lida
  def mark_as_read!
    update(read: true)
  end

  # Verificar se o usuário pode ver a mensagem
  def visible_to?(user_id)
    chat.participant?(user_id)
  end

  # Verificar se o usuário é o remetente
  def sent_by?(user_id)
    sender_id == user_id
  end

  # Obter URL do anexo
  def attachment_url
    return nil unless attachment.attached?
    
    begin
      Rails.application.routes.url_helpers.url_for(attachment)
    rescue ArgumentError => e
      if e.message.include?("Missing host")
        Rails.application.routes.url_helpers.rails_blob_url(attachment, host: "192.168.1.8:3000")
      else
        raise e
      end
    end
  end

  private

  def mark_as_read_for_sender
    # Marcar como lida automaticamente para o remetente
    update(read: true) if sender_id == chat.user1_id || sender_id == chat.user2_id
  end
end 