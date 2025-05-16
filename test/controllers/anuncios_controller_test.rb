require "test_helper"

class AnunciosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @anuncio = anuncios(:one)
  end

  test "should get index" do
    get anuncios_url, as: :json
    assert_response :success
  end

  test "should create anuncio" do
    assert_difference("Anuncio.count") do
      post anuncios_url, params: { anuncio: { descricao: @anuncio.descricao, local_id: @anuncio.local_id, titulo: @anuncio.titulo, user_id: @anuncio.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show anuncio" do
    get anuncio_url(@anuncio), as: :json
    assert_response :success
  end

  test "should update anuncio" do
    patch anuncio_url(@anuncio), params: { anuncio: { descricao: @anuncio.descricao, local_id: @anuncio.local_id, titulo: @anuncio.titulo, user_id: @anuncio.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy anuncio" do
    assert_difference("Anuncio.count", -1) do
      delete anuncio_url(@anuncio), as: :json
    end

    assert_response :no_content
  end
end
