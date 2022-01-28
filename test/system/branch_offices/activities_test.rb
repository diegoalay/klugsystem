require "application_system_test_case"

class BranchOffices::ActivitiesTest < ApplicationSystemTestCase
  setup do
    @branch_offices_activity = branch_offices_activities(:one)
  end

  test "visiting the index" do
    visit branch_offices_activities_url
    assert_selector "h1", text: "Branch Offices/Activities"
  end

  test "creating a Activity" do
    visit branch_offices_activities_url
    click_on "New Branch Offices/Activity"

    click_on "Create Activity"

    assert_text "Activity was successfully created"
    click_on "Back"
  end

  test "updating a Activity" do
    visit branch_offices_activities_url
    click_on "Edit", match: :first

    click_on "Update Activity"

    assert_text "Activity was successfully updated"
    click_on "Back"
  end

  test "destroying a Activity" do
    visit branch_offices_activities_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Activity was successfully destroyed"
  end
end
