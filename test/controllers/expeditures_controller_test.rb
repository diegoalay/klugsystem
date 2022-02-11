require "test_helper"

class ExpedituresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expediture = expeditures(:one)
  end

  test "should get index" do
    get expeditures_url
    assert_response :success
  end

  test "should get new" do
    get new_expediture_url
    assert_response :success
  end

  test "should create expediture" do
    assert_difference('Expediture.count') do
      post expeditures_url, params: { expediture: {  } }
    end

    assert_redirected_to expediture_url(Expediture.last)
  end

  test "should show expediture" do
    get expediture_url(@expediture)
    assert_response :success
  end

  test "should get edit" do
    get edit_expediture_url(@expediture)
    assert_response :success
  end

  test "should update expediture" do
    patch expediture_url(@expediture), params: { expediture: {  } }
    assert_redirected_to expediture_url(@expediture)
  end

  test "should destroy expediture" do
    assert_difference('Expediture.count', -1) do
      delete expediture_url(@expediture)
    end

    assert_redirected_to expeditures_url
  end
end
