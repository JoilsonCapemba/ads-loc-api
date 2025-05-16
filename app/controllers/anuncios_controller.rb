class AnunciosController < ApplicationController
  before_action :set_anuncio, only: %i[ show update destroy ]

  # GET /anuncios
  def index
    @anuncios = Anuncio.all

    render json: @anuncios
  end

  # GET /anuncios/1
  def show
    render json: @anuncio
  end

  # POST /anuncios
  def create
    @anuncio = Anuncio.new(anuncio_params)

    if @anuncio.save
      render json: @anuncio, status: :created, location: @anuncio
    else
      render json: @anuncio.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /anuncios/1
  def update
    if @anuncio.update(anuncio_params)
      render json: @anuncio
    else
      render json: @anuncio.errors, status: :unprocessable_entity
    end
  end

  # DELETE /anuncios/1
  def destroy
    @anuncio.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_anuncio
      @anuncio = Anuncio.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def anuncio_params
      params.expect(anuncio: [ :titulo, :descricao, :local_id, :user_id, :fotos ])
    end
end
