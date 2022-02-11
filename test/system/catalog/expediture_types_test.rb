require "application_system_test_case"

class Catalog::ExpeditureTypesTest < ApplicationSystemTestCase
  setup do
    @catalog_expediture_type = catalog_expediture_types(:one)
  end

  test "visiting the index" do
    visit catalog_expediture_types_url
    assert_selector "h1", text: "Catalog/Expediture Types"
  end

  test "creating a Expediture type" do
    visit catalog_expediture_types_url
    click_on "New Catalog/Expediture Type"

    click_on "Create Expediture type"

    assert_text "Expediture type was successfully created"
    click_on "Back"
  end

  test "updating a Expediture type" do
    visit catalog_expediture_types_url
    click_on "Edit", match: :first

    click_on "Update Expediture type"

    assert_text "Expediture type was successfully updated"
    click_on "Back"
  end

  test "destroying a Expediture type" do
    visit catalog_expediture_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Expediture type was successfully destroyed"
  end
end
