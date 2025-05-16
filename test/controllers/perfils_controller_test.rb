require "test_helper"

class PerfilsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @perfil = perfils(:one)
  end

  test "should get index" do
    get perfils_url, as: :json
    assert_response :success
  end

  test "should create perfil" do
    assert_difference("Perfil.count") do
      post perfils_url, params: { perfil: { descricao: @perfil.descricao } }, as: :json
    end

    assert_response :created
  end

  test "should show perfil" do
    get perfil_url(@perfil), as: :json
    assert_response :success
  end

  test "should update perfil" do
    patch perfil_url(@perfil), params: { perfil: { descricao: @perfil.descricao } }, as: :json
    assert_response :success
  end

  test "should destroy perfil" do
    assert_difference("Perfil.count", -1) do
      delete perfil_url(@perfil), as: :json
    end

    assert_response :no_content
  end
end
