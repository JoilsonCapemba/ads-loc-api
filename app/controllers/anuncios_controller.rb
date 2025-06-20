class AnunciosController < ApplicationController
  before_action :authorize
  before_action :set_anuncio, only: %i[ show update destroy ]

  # GET /anuncios
  def index
    if params[:user_id]
      @anuncios = Anuncio.where(user_id: params[:user_id])
    else
      @anuncios = Anuncio.all
    end

    render json: @anuncios.as_json(methods: [:local_nome, :user_nome, :fotos_url])
  end

  # GET /anuncios/1
  def show
    render json: @anuncio
  end

  # POST /anuncios
  def create
    @anuncio = Anuncio.new(anuncio_params.except(:fotos))
    fotos_param = (params[:anuncio][:fotos] if params[:anuncio]) || params[:fotos]
    if fotos_param.present?
      if fotos_param.is_a?(Array)
        fotos_param.each { |foto| @anuncio.fotos.attach(foto) }
      else
        @anuncio.fotos.attach(fotos_param)
      end
    end

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
      params.require(:anuncio).permit(:titulo, :descricao, :local_id, :user_id, :tag_descricao, fotos: [])
    end
end
