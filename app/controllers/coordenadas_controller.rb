class CoordenadasController < ApplicationController
  before_action :set_coordenada, only: %i[ show update destroy ]

  # GET /coordenadas
  def index
    @coordenadas = Coordenada.all

    render json: @coordenadas
  end

  # GET /coordenadas/1
  def show
    render json: @coordenada
  end

  # POST /coordenadas
  def create
    @coordenada = Coordenada.new(coordenada_params)

    if @coordenada.save
      render json: @coordenada, status: :created, location: @coordenada
    else
      render json: @coordenada.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /coordenadas/1
  def update
    if @coordenada.update(coordenada_params)
      render json: @coordenada
    else
      render json: @coordenada.errors, status: :unprocessable_entity
    end
  end

  # DELETE /coordenadas/1
  def destroy
    @coordenada.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coordenada
      @coordenada = Coordenada.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def coordenada_params
      params.expect(coordenada: [ :latitude, :longitude, :raio ])
    end
end
