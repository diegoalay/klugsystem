require "test_helper"

class Employees::ActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employees_activity = employees_activities(:one)
  end

  test "should get index" do
    get employees_activities_url
    assert_response :success
  end

  test "should get new" do
    get new_employees_activity_url
    assert_response :success
  end

  test "should create employees_activity" do
    assert_difference('Employees::Activity.count') do
      post employees_activities_url, params: { employees_activity: {  } }
    end

    assert_redirected_to employees_activity_url(Employees::Activity.last)
  end

  test "should show employees_activity" do
    get employees_activity_url(@employees_activity)
    assert_response :success
  end

  test "should get edit" do
    get edit_employees_activity_url(@employees_activity)
    assert_response :success
  end

  test "should update employees_activity" do
    patch employees_activity_url(@employees_activity), params: { employees_activity: {  } }
    assert_redirected_to employees_activity_url(@employees_activity)
  end

  test "should destroy employees_activity" do
    assert_difference('Employees::Activity.count', -1) do
      delete employees_activity_url(@employees_activity)
    end

    assert_redirected_to employees_activities_url
  end
end
