require "test_helper"

class BranchOffices::ActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @branch_offices_activity = branch_offices_activities(:one)
  end

  test "should get index" do
    get branch_offices_activities_url
    assert_response :success
  end

  test "should get new" do
    get new_branch_offices_activity_url
    assert_response :success
  end

  test "should create branch_offices_activity" do
    assert_difference('BranchOffices::Activity.count') do
      post branch_offices_activities_url, params: { branch_offices_activity: {  } }
    end

    assert_redirected_to branch_offices_activity_url(BranchOffices::Activity.last)
  end

  test "should show branch_offices_activity" do
    get branch_offices_activity_url(@branch_offices_activity)
    assert_response :success
  end

  test "should get edit" do
    get edit_branch_offices_activity_url(@branch_offices_activity)
    assert_response :success
  end

  test "should update branch_offices_activity" do
    patch branch_offices_activity_url(@branch_offices_activity), params: { branch_offices_activity: {  } }
    assert_redirected_to branch_offices_activity_url(@branch_offices_activity)
  end

  test "should destroy branch_offices_activity" do
    assert_difference('BranchOffices::Activity.count', -1) do
      delete branch_offices_activity_url(@branch_offices_activity)
    end

    assert_redirected_to branch_offices_activities_url
  end
end
