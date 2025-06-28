class ChatsController < ApplicationController
  before_action :authorize
  before_action :set_chat, only: [:show, :messages]

  # GET /chats - Listar chats do usuário
  def index
    user_id = @current_user.id
    
    # Buscar chats onde o usuário é user1 ou user2
    chats = Chat.where(user1_id: user_id).or(Chat.where(user2_id: user_id))
                 .includes(:user1, :user2, :messages)
                 .order(updated_at: :desc)

    # Formatar resposta com informações do outro participante e última mensagem
    formatted_chats = chats.map do |chat|
      other_user = chat.other_participant(user_id)
      last_message = chat.messages.order(created_at: :desc).first
      unread_count = chat.messages.unread_by(user_id).count

      {
        id: chat.id,
        other_user: {
          id: other_user.id,
          username: other_user.username,
          full_name: other_user.full_name,
          avatar_url: other_user.avatar_url
        },
        last_message: last_message ? {
          content: last_message.content,
          sender_id: last_message.sender_id,
          created_at: last_message.created_at,
          read: last_message.read
        } : nil,
        unread_count: unread_count,
        updated_at: chat.updated_at
      }
    end

    render json: formatted_chats
  end

  # GET /chats/:id - Mostrar chat específico
  def show
    unless @chat.participant?(@current_user.id)
      render json: { error: "Acesso negado" }, status: :forbidden
      return
    end

    other_user = @chat.other_participant(@current_user.id)
    
    render json: {
      id: @chat.id,
      other_user: {
        id: other_user.id,
        username: other_user.username,
        full_name: other_user.full_name,
        avatar_url: other_user.avatar_url
      },
      created_at: @chat.created_at,
      updated_at: @chat.updated_at
    }
  end

  # POST /chats - Criar novo chat
  def create
    other_user_id = params[:other_user_id]
    
    Rails.logger.info "=== DEBUG CREATE CHAT ==="
    Rails.logger.info "other_user_id: #{other_user_id}"
    Rails.logger.info "other_user_id class: #{other_user_id.class}"
    Rails.logger.info "current_user_id: #{@current_user.id}"
    
    unless other_user_id
      render json: { error: "other_user_id é obrigatório" }, status: :unprocessable_entity
      return
    end

    # Verificar se o usuário não está tentando criar chat consigo mesmo
    if other_user_id.to_i == @current_user.id
      render json: { error: "Não é possível criar chat consigo mesmo" }, status: :unprocessable_entity
      return
    end

    # Verificar se o outro usuário existe
    Rails.logger.info "Procurando usuário com ID: #{other_user_id}"
    Rails.logger.info "Tipo do other_user_id: #{other_user_id.class}"
    Rails.logger.info "other_user_id.to_i: #{other_user_id.to_i}"
    
    # Tentar diferentes formas de buscar o usuário
    other_user = User.find_by(id: other_user_id)
    Rails.logger.info "find_by(id: #{other_user_id}) retornou: #{other_user&.full_name || 'nil'}"
    
    if other_user.nil?
      other_user = User.find_by(id: other_user_id.to_i)
      Rails.logger.info "find_by(id: #{other_user_id.to_i}) retornou: #{other_user&.full_name || 'nil'}"
    end
    
    if other_user.nil?
      begin
        other_user = User.find(other_user_id.to_i)
        Rails.logger.info "find(#{other_user_id.to_i}) retornou: #{other_user&.full_name || 'nil'}"
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.error "RecordNotFound: #{e.message}"
      end
    end
    
    Rails.logger.info "other_user final: #{other_user&.full_name || 'nil'}"
    Rails.logger.info "other_user class: #{other_user.class}"
    
    unless other_user
      render json: { error: "Usuário não encontrado" }, status: :not_found
      return
    end

    # Criar ou buscar chat existente
    Rails.logger.info "Criando chat entre usuários #{@current_user.id} e #{other_user_id}"
    chat = Chat.find_or_create_between_users(@current_user.id, other_user_id)
    
    # Validar se o chat foi criado
    unless chat
      render json: { error: "Erro ao criar chat" }, status: :internal_server_error
      return
    end
    
    Rails.logger.info "Chat criado com sucesso: #{chat.id}"
    
    # Retornar resposta simples
    render json: {
      id: chat.id,
      other_user: {
        id: other_user.id,
        username: other_user.username,
        full_name: other_user.full_name,
        avatar_url: other_user.respond_to?(:avatar_url) ? other_user.avatar_url : nil
      },
      created_at: chat.created_at,
      updated_at: chat.updated_at
    }, status: :created
  end

  # GET /chats/:id/messages - Listar mensagens do chat
  def messages
    unless @chat.participant?(@current_user.id)
      render json: { error: "Acesso negado" }, status: :forbidden
      return
    end

    messages = @chat.messages.includes(:sender)
                   .order(created_at: :asc)
                   .limit(50) # Limitar a 50 mensagens por vez

    formatted_messages = messages.map do |message|
      {
        id: message.id,
        content: message.content,
        sender_id: message.sender_id,
        sender_name: message.sender.full_name,
        sender_username: message.sender.username,
        attachment_url: message.attachment_url,
        read: message.read,
        created_at: message.created_at
      }
    end

    render json: formatted_messages
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Chat não encontrado" }, status: :not_found
  end
end 