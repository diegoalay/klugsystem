require "application_system_test_case"

class CashRegister::ActivitiesTest < ApplicationSystemTestCase
  setup do
    @cash_register_activity = cash_register_activities(:one)
  end

  test "visiting the index" do
    visit cash_register_activities_url
    assert_selector "h1", text: "Cash Register/Activities"
  end

  test "creating a Activity" do
    visit cash_register_activities_url
    click_on "New Cash Register/Activity"

    click_on "Create Activity"

    assert_text "Activity was successfully created"
    click_on "Back"
  end

  test "updating a Activity" do
    visit cash_register_activities_url
    click_on "Edit", match: :first

    click_on "Update Activity"

    assert_text "Activity was successfully updated"
    click_on "Back"
  end

  test "destroying a Activity" do
    visit cash_register_activities_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Activity was successfully destroyed"
  end
end
