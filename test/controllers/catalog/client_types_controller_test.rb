require "test_helper"

class Catalog::ClientTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_client_type = catalog_client_types(:one)
  end

  test "should get index" do
    get catalog_client_types_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_client_type_url
    assert_response :success
  end

  test "should create catalog_client_type" do
    assert_difference('Catalog::ClientType.count') do
      post catalog_client_types_url, params: { catalog_client_type: {  } }
    end

    assert_redirected_to catalog_client_type_url(Catalog::ClientType.last)
  end

  test "should show catalog_client_type" do
    get catalog_client_type_url(@catalog_client_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_client_type_url(@catalog_client_type)
    assert_response :success
  end

  test "should update catalog_client_type" do
    patch catalog_client_type_url(@catalog_client_type), params: { catalog_client_type: {  } }
    assert_redirected_to catalog_client_type_url(@catalog_client_type)
  end

  test "should destroy catalog_client_type" do
    assert_difference('Catalog::ClientType.count', -1) do
      delete catalog_client_type_url(@catalog_client_type)
    end

    assert_redirected_to catalog_client_types_url
  end
end
