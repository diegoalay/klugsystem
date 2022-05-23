require "test_helper"

class User::LogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_log = user_logs(:one)
  end

  test "should get index" do
    get user_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_user_log_url
    assert_response :success
  end

  test "should create user_log" do
    assert_difference('User::Log.count') do
      post user_logs_url, params: { user_log: {  } }
    end

    assert_redirected_to user_log_url(User::Log.last)
  end

  test "should show user_log" do
    get user_log_url(@user_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_log_url(@user_log)
    assert_response :success
  end

  test "should update user_log" do
    patch user_log_url(@user_log), params: { user_log: {  } }
    assert_redirected_to user_log_url(@user_log)
  end

  test "should destroy user_log" do
    assert_difference('User::Log.count', -1) do
      delete user_log_url(@user_log)
    end

    assert_redirected_to user_logs_url
  end
end
