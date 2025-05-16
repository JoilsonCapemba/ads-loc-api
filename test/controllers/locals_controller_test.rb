require "test_helper"

class LocalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @local = locals(:one)
  end

  test "should get index" do
    get locals_url, as: :json
    assert_response :success
  end

  test "should create local" do
    assert_difference("Local.count") do
      post locals_url, params: { local: { coordenada_id: @local.coordenada_id, nome: @local.nome } }, as: :json
    end

    assert_response :created
  end

  test "should show local" do
    get local_url(@local), as: :json
    assert_response :success
  end

  test "should update local" do
    patch local_url(@local), params: { local: { coordenada_id: @local.coordenada_id, nome: @local.nome } }, as: :json
    assert_response :success
  end

  test "should destroy local" do
    assert_difference("Local.count", -1) do
      delete local_url(@local), as: :json
    end

    assert_response :no_content
  end
end
