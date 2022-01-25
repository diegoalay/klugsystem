require "test_helper"

class Client::ActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client_activity = client_activities(:one)
  end

  test "should get index" do
    get client_activities_url
    assert_response :success
  end

  test "should get new" do
    get new_client_activity_url
    assert_response :success
  end

  test "should create client_activity" do
    assert_difference('Client::Activity.count') do
      post client_activities_url, params: { client_activity: {  } }
    end

    assert_redirected_to client_activity_url(Client::Activity.last)
  end

  test "should show client_activity" do
    get client_activity_url(@client_activity)
    assert_response :success
  end

  test "should get edit" do
    get edit_client_activity_url(@client_activity)
    assert_response :success
  end

  test "should update client_activity" do
    patch client_activity_url(@client_activity), params: { client_activity: {  } }
    assert_redirected_to client_activity_url(@client_activity)
  end

  test "should destroy client_activity" do
    assert_difference('Client::Activity.count', -1) do
      delete client_activity_url(@client_activity)
    end

    assert_redirected_to client_activities_url
  end
end
