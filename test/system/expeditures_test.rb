require "application_system_test_case"

class ExpedituresTest < ApplicationSystemTestCase
  setup do
    @expediture = expeditures(:one)
  end

  test "visiting the index" do
    visit expeditures_url
    assert_selector "h1", text: "Expeditures"
  end

  test "creating a Expediture" do
    visit expeditures_url
    click_on "New Expediture"

    click_on "Create Expediture"

    assert_text "Expediture was successfully created"
    click_on "Back"
  end

  test "updating a Expediture" do
    visit expeditures_url
    click_on "Edit", match: :first

    click_on "Update Expediture"

    assert_text "Expediture was successfully updated"
    click_on "Back"
  end

  test "destroying a Expediture" do
    visit expeditures_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Expediture was successfully destroyed"
  end
end
