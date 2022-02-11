require "test_helper"

class Catalog::ExpeditureTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_expediture_type = catalog_expediture_types(:one)
  end

  test "should get index" do
    get catalog_expediture_types_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_expediture_type_url
    assert_response :success
  end

  test "should create catalog_expediture_type" do
    assert_difference('Catalog::ExpeditureType.count') do
      post catalog_expediture_types_url, params: { catalog_expediture_type: {  } }
    end

    assert_redirected_to catalog_expediture_type_url(Catalog::ExpeditureType.last)
  end

  test "should show catalog_expediture_type" do
    get catalog_expediture_type_url(@catalog_expediture_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_expediture_type_url(@catalog_expediture_type)
    assert_response :success
  end

  test "should update catalog_expediture_type" do
    patch catalog_expediture_type_url(@catalog_expediture_type), params: { catalog_expediture_type: {  } }
    assert_redirected_to catalog_expediture_type_url(@catalog_expediture_type)
  end

  test "should destroy catalog_expediture_type" do
    assert_difference('Catalog::ExpeditureType.count', -1) do
      delete catalog_expediture_type_url(@catalog_expediture_type)
    end

    assert_redirected_to catalog_expediture_types_url
  end
end
