class MessagesController < ApplicationController
  before_action :authorize
  before_action :set_chat, only: [:index, :create]
  before_action :set_message, only: [:show, :mark_as_read]

  # GET /chats/:chat_id/messages - Listar mensagens do chat
  def index
    Rails.logger.info "=== DEBUG GET MESSAGES ==="
    Rails.logger.info "chat_id: #{params[:chat_id]}"
    Rails.logger.info "current_user_id: #{@current_user.id}"
    
    unless @chat.participant?(@current_user.id)
      Rails.logger.error "Usuário #{@current_user.id} não é participante do chat #{@chat.id}"
      render json: { error: "Acesso negado" }, status: :forbidden
      return
    end

    messages = @chat.messages.includes(:sender)
                   .order(created_at: :asc)
                   .limit(50)

    Rails.logger.info "Mensagens encontradas: #{messages.count}"

    formatted_messages = messages.map do |message|
      Rails.logger.info "Formatando mensagem: ID=#{message.id}, Content='#{message.content}', Sender=#{message.sender_id}"
      {
        id: message.id,
        content: message.content,
        sender_id: message.sender_id,
        sender_name: message.sender.full_name,
        sender_username: message.sender.username,
        attachment_url: message.attachment_url,
        read: message.read,
        created_at: message.created_at.iso8601
      }
    end

    Rails.logger.info "Mensagens formatadas: #{formatted_messages.size}"
    render json: formatted_messages
  end

  # POST /chats/:chat_id/messages - Enviar nova mensagem
  def create
    Rails.logger.info "=== DEBUG CREATE MESSAGE ==="
    Rails.logger.info "chat_id: #{params[:chat_id]}"
    Rails.logger.info "current_user_id: #{@current_user.id}"
    Rails.logger.info "chat: #{@chat.inspect}"
    
    unless @chat.participant?(@current_user.id)
      Rails.logger.error "Usuário #{@current_user.id} não é participante do chat #{@chat.id}"
      render json: { error: "Acesso negado" }, status: :forbidden
      return
    end

    # Log para debug
    Rails.logger.info "Parâmetros recebidos: #{params.inspect}"
    Rails.logger.info "Message params: #{message_params.inspect}"

    @message = @chat.messages.build(message_params)
    @message.sender = @current_user

    if @message.save
      # Atualizar timestamp do chat
      @chat.touch

      # Formatar resposta
      formatted_message = {
        id: @message.id,
        content: @message.content,
        sender_id: @message.sender_id,
        sender_name: @message.sender.full_name,
        sender_username: @message.sender.username,
        attachment_url: @message.attachment_url,
        read: @message.read,
        created_at: @message.created_at.iso8601
      }

      Rails.logger.info "Mensagem criada com sucesso: #{@message.id}"
      render json: formatted_message, status: :created
    else
      Rails.logger.error "Erro ao salvar mensagem: #{@message.errors.full_messages}"
      render json: { 
        error: "Erro ao enviar mensagem",
        details: @message.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  # GET /messages/:id - Mostrar mensagem específica
  def show
    unless @message.visible_to?(@current_user.id)
      render json: { error: "Acesso negado" }, status: :forbidden
      return
    end

    render json: {
      id: @message.id,
      content: @message.content,
      sender_id: @message.sender_id,
      sender_name: @message.sender.full_name,
      sender_username: @message.sender.username,
      attachment_url: @message.attachment_url,
      read: @message.read,
      created_at: @message.created_at
    }
  end

  # PATCH /messages/:id/mark_as_read - Marcar mensagem como lida
  def mark_as_read
    unless @message.visible_to?(@current_user.id)
      render json: { error: "Acesso negado" }, status: :forbidden
      return
    end

    # Só pode marcar como lida se não for o remetente
    unless @message.sent_by?(@current_user.id)
      @message.mark_as_read!
    end

    render json: { success: true }
  end

  # GET /messages/unread_count - Contar mensagens não lidas
  def unread_count
    user_id = @current_user.id
    
    # Buscar chats do usuário
    chats = Chat.where(user1_id: user_id).or(Chat.where(user2_id: user_id))
    
    # Contar mensagens não lidas
    unread_count = Message.joins(:chat)
                          .where(chats: { id: chats.pluck(:id) })
                          .where.not(sender_id: user_id)
                          .where(read: false)
                          .count

    render json: { unread_count: unread_count }
  end

  private

  def set_chat
    Rails.logger.info "set_chat - chat_id: #{params[:chat_id]}"
    @chat = Chat.find(params[:chat_id])
    Rails.logger.info "Chat encontrado: #{@chat.inspect}"
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "Chat não encontrado: #{params[:chat_id]}"
    render json: { error: "Chat não encontrado" }, status: :not_found
  end

  def set_message
    @message = Message.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Mensagem não encontrada" }, status: :not_found
  end

  def message_params
    # Aceitar tanto message[content] quanto content diretamente
    if params[:message].present?
      params.require(:message).permit(:content, :attachment)
    else
      # Se não há message, aceitar content diretamente
      { content: params[:content] }
    end
  end
end 