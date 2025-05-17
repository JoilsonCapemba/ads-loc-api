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

  # POST /users
  def create
    @user = User.new(user_params)


    if @user.save
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
  end

  def login
    @user = User.find_by(email: user_params[:email])
    if @user.authenticate(user_params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: :ok
    else
      render json: { error: "Usuario ou password invalida" }, status: :unprocessable_entity
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


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :password, :username, :full_name, :saldo, :avatar)
  end
end
