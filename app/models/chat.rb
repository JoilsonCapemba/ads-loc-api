class Chat < ApplicationRecord
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'
  has_many :messages, dependent: :destroy

  # Validações
  validates :user1_id, presence: true
  validates :user2_id, presence: true
  validate :users_must_be_different
  validate :chat_must_be_unique

  # Garantir que user1_id < user2_id para evitar duplicatas
  before_create :normalize_user_order

  # Buscar chat entre dois usuários
  def self.between_users(user1_id, user2_id)
    user1_id, user2_id = [user1_id.to_i, user2_id.to_i].sort
    find_by(user1_id: user1_id, user2_id: user2_id)
  end

  # Criar ou buscar chat entre dois usuários
  def self.find_or_create_between_users(user1_id, user2_id)
    chat = between_users(user1_id, user2_id)
    return chat if chat

    chat = create(user1_id: user1_id.to_i, user2_id: user2_id.to_i)
    raise "Erro ao criar chat" if chat.nil?
    chat
  end

  # Verificar se um usuário participa do chat
  def participant?(user_id)
    user1_id == user_id || user2_id == user_id
  end

  # Obter o outro participante do chat
  def other_participant(user_id)
    return user2 if user1_id == user_id
    return user1 if user2_id == user_id
    nil
  end

  private

  def normalize_user_order
    if user1_id > user2_id
      self.user1_id, self.user2_id = user2_id, user1_id
    end
  end

  def users_must_be_different
    if user1_id == user2_id
      errors.add(:base, "Não é possível criar chat consigo mesmo")
    end
  end

  def chat_must_be_unique
    # Verificar se já existe um chat entre esses usuários (em qualquer ordem)
    existing_chat = Chat.where(
      "(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)",
      user1_id, user2_id, user2_id, user1_id
    ).where.not(id: id).first
    
    if existing_chat
      errors.add(:base, "Chat já existe entre esses usuários")
    end
  end
end 