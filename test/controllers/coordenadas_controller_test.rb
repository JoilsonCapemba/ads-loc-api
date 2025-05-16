require "test_helper"

class CoordenadasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coordenada = coordenadas(:one)
  end

  test "should get index" do
    get coordenadas_url, as: :json
    assert_response :success
  end

  test "should create coordenada" do
    assert_difference("Coordenada.count") do
      post coordenadas_url, params: { coordenada: { latitude: @coordenada.latitude, longitude: @coordenada.longitude, raio: @coordenada.raio } }, as: :json
    end

    assert_response :created
  end

  test "should show coordenada" do
    get coordenada_url(@coordenada), as: :json
    assert_response :success
  end

  test "should update coordenada" do
    patch coordenada_url(@coordenada), params: { coordenada: { latitude: @coordenada.latitude, longitude: @coordenada.longitude, raio: @coordenada.raio } }, as: :json
    assert_response :success
  end

  test "should destroy coordenada" do
    assert_difference("Coordenada.count", -1) do
      delete coordenada_url(@coordenada), as: :json
    end

    assert_response :no_content
  end
end
