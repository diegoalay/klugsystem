require "application_system_test_case"

class Catalog::ClientTypesTest < ApplicationSystemTestCase
  setup do
    @catalog_client_type = catalog_client_types(:one)
  end

  test "visiting the index" do
    visit catalog_client_types_url
    assert_selector "h1", text: "Catalog/Client Types"
  end

  test "creating a Client type" do
    visit catalog_client_types_url
    click_on "New Catalog/Client Type"

    click_on "Create Client type"

    assert_text "Client type was successfully created"
    click_on "Back"
  end

  test "updating a Client type" do
    visit catalog_client_types_url
    click_on "Edit", match: :first

    click_on "Update Client type"

    assert_text "Client type was successfully updated"
    click_on "Back"
  end

  test "destroying a Client type" do
    visit catalog_client_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Client type was successfully destroyed"
  end
end
