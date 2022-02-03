require "test_helper"

class CashRegister::ActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cash_register_activity = cash_register_activities(:one)
  end

  test "should get index" do
    get cash_register_activities_url
    assert_response :success
  end

  test "should get new" do
    get new_cash_register_activity_url
    assert_response :success
  end

  test "should create cash_register_activity" do
    assert_difference('CashRegister::Activity.count') do
      post cash_register_activities_url, params: { cash_register_activity: {  } }
    end

    assert_redirected_to cash_register_activity_url(CashRegister::Activity.last)
  end

  test "should show cash_register_activity" do
    get cash_register_activity_url(@cash_register_activity)
    assert_response :success
  end

  test "should get edit" do
    get edit_cash_register_activity_url(@cash_register_activity)
    assert_response :success
  end

  test "should update cash_register_activity" do
    patch cash_register_activity_url(@cash_register_activity), params: { cash_register_activity: {  } }
    assert_redirected_to cash_register_activity_url(@cash_register_activity)
  end

  test "should destroy cash_register_activity" do
    assert_difference('CashRegister::Activity.count', -1) do
      delete cash_register_activity_url(@cash_register_activity)
    end

    assert_redirected_to cash_register_activities_url
  end
end
