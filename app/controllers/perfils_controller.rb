class PerfilsController < ApplicationController
  before_action :authorize
  before_action :set_perfil, only: %i[ show update destroy ]

  # GET /perfils
  def index
    @perfils = Perfil.all.order(:descricao)
    render json: @perfils
  end

  # GET /perfils/1
  def show
    render json: @perfil
  end

  # POST /perfils
  def create
    @perfil = Perfil.new(perfil_params)

    if @perfil.save
      render json: @perfil, status: :created
    else
      render json: { 
        error: "Erro ao criar perfil",
        details: @perfil.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /perfils/1
  def update
    if @perfil.update(perfil_params)
      render json: @perfil
    else
      render json: { 
        error: "Erro ao atualizar perfil",
        details: @perfil.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  # DELETE /perfils/1
  def destroy
    if @perfil.users.any?
      render json: { 
        error: "Não é possível excluir um perfil que está sendo usado por usuários" 
      }, status: :unprocessable_entity
    else
      @perfil.destroy!
      head :no_content
    end
  end

  private
    def set_perfil
      @perfil = Perfil.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Perfil não encontrado" }, status: :not_found
    end

    def perfil_params
      params.require(:perfil).permit(:descricao)
    end
end
