class UsersController < ApplicationController
  before_action :authorize, except: [ :create, :login ]
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # GET /users/profile
  def profile
    if @current_user
      render json: {
        id: @current_user.id,
        fullName: @current_user.full_name,
        username: @current_user.username,
        email: @current_user.email,
        saldo: @current_user.saldo,
        photoUrl: @current_user.avatar_url,
        perfis: @current_user.perfils
      }
    else
      render json: { error: "Usuário não encontrado" }, status: :not_found
    end
  end

  # PUT /users/profile
  def update_profile
    if @current_user
      @current_user.full_name = params[:fullName] if params[:fullName]
      @current_user.username = params[:username] if params[:username]
      @current_user.email = params[:email] if params[:email]
      if params[:perfis]
        @current_user.perfils = Perfil.where(id: params[:perfis])
      end
      if @current_user.save
        render json: {
          id: @current_user.id,
          fullName: @current_user.full_name,
          username: @current_user.username,
          email: @current_user.email,
          saldo: @current_user.saldo,
          photoUrl: @current_user.avatar_url,
          perfis: @current_user.perfils
        }
      else
        render json: { 
          error: "Erro ao atualizar usuário",
          details: @current_user.errors.full_messages
        }, status: :unprocessable_entity
      end
    else
      render json: { error: "Usuário não encontrado" }, status: :not_found
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)
    
    if @user.save
      token = encode_token({ user_id: @user.id })
      render json: { 
        user: @user.as_json(except: [:password_digest]).merge(photoUrl: @user.avatar_url), 
        token: token 
      }, status: :created
    else
      render json: { 
        error: "Erro ao criar usuário",
        details: @user.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: { 
        error: "Erro ao atualizar usuário",
        details: @user.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
  end

  def login
    @user = User.find_by(username: params[:user][:username])
    
    if @user&.authenticate(params[:user][:password])
      token = encode_token({ user_id: @user.id })
      render json: { 
        user: @user.as_json(except: [:password_digest]), 
        token: token 
      }, status: :ok
    else
      render json: { 
        error: "Usuário ou senha inválidos" 
      }, status: :unprocessable_entity
    end
  end

  def dentro_do_raio?(lat1, lon1, lat2, lon2, raio_km = 2)
    raio_da_terra_km = 6371.0

    dlat = to_radian(lat2 - lat1)
    dlon = to_radian(lon2 - lon1)

    a = Math.sin(dlat / 2)**2 +
        Math.cos(to_radian(lat1)) * Math.cos(to_radian(lat2)) *
        Math.sin(dlon / 2)**2

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    distancia = raio_da_terra_km * c

    distancia <= raio_km
  end

  def to_radian(degree)
    degree * Math::PI / 180
  end

  # POST /users/profile/photo
  def upload_photo
    if @current_user && params[:photo]
      @current_user.avatar.attach(params[:photo])
      if @current_user.save
        render json: {
          id: @current_user.id,
          fullName: @current_user.full_name,
          username: @current_user.username,
          email: @current_user.email,
          saldo: @current_user.saldo,
          photoUrl: @current_user.avatar_url,
          perfis: @current_user.perfils
        }
      else
        render json: { 
          error: "Erro ao salvar foto",
          details: @current_user.errors.full_messages 
        }, status: :unprocessable_entity
      end
    else
      render json: { error: "Foto não fornecida" }, status: :bad_request
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Usuário não encontrado" }, status: :not_found
    end

    def user_params
      params.require(:user).permit(:email, :password, :username, :full_name, :saldo, :avatar)
    end
end
