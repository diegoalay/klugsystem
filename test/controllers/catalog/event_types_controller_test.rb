require "test_helper"

class Catalog::EventTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_event_type = catalog_event_types(:one)
  end

  test "should get index" do
    get catalog_event_types_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_event_type_url
    assert_response :success
  end

  test "should create catalog_event_type" do
    assert_difference('Catalog::EventType.count') do
      post catalog_event_types_url, params: { catalog_event_type: {  } }
    end

    assert_redirected_to catalog_event_type_url(Catalog::EventType.last)
  end

  test "should show catalog_event_type" do
    get catalog_event_type_url(@catalog_event_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_event_type_url(@catalog_event_type)
    assert_response :success
  end

  test "should update catalog_event_type" do
    patch catalog_event_type_url(@catalog_event_type), params: { catalog_event_type: {  } }
    assert_redirected_to catalog_event_type_url(@catalog_event_type)
  end

  test "should destroy catalog_event_type" do
    assert_difference('Catalog::EventType.count', -1) do
      delete catalog_event_type_url(@catalog_event_type)
    end

    assert_redirected_to catalog_event_types_url
  end
end
