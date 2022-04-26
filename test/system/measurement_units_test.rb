require "application_system_test_case"

class MeasurementUnitsTest < ApplicationSystemTestCase
  setup do
    @measurement_unit = measurement_units(:one)
  end

  test "visiting the index" do
    visit measurement_units_url
    assert_selector "h1", text: "Measurement Units"
  end

  test "creating a Measurement unit" do
    visit measurement_units_url
    click_on "New Measurement Unit"

    click_on "Create Measurement unit"

    assert_text "Measurement unit was successfully created"
    click_on "Back"
  end

  test "updating a Measurement unit" do
    visit measurement_units_url
    click_on "Edit", match: :first

    click_on "Update Measurement unit"

    assert_text "Measurement unit was successfully updated"
    click_on "Back"
  end

  test "destroying a Measurement unit" do
    visit measurement_units_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Measurement unit was successfully destroyed"
  end
end
