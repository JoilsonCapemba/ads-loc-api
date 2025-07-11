class ApplicationController < ActionController::API
  def encode_token(payload)
    JWT.encode(payload, "secret")
  end

  def decoded_token
    auth_header = request.headers["Authorization"]
    if auth_header
      token = auth_header.split(" ").last

      begin
        JWT.decode(token, "secret", true, algorithm: "HS256")
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def authorized_user
    decoded_token = decoded_token()
    if decoded_token
      user_id = decoded_token[0]["user_id"]
      @current_user = User.find_by(id: user_id)
    end
    @current_user.present?
  end

  def authorize
    unless authorized_user
      render json: { 
        error: "Não autorizado",
        message: "Você precisa estar logado" 
      }, status: :unauthorized
    end
  end
end
