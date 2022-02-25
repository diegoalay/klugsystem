require "application_system_test_case"

class Catalog::ProductTransactionTypesTest < ApplicationSystemTestCase
  setup do
    @catalog_product_transaction_type = catalog_product_transaction_types(:one)
  end

  test "visiting the index" do
    visit catalog_product_transaction_types_url
    assert_selector "h1", text: "Catalog/Product Transaction Types"
  end

  test "creating a Product transaction type" do
    visit catalog_product_transaction_types_url
    click_on "New Catalog/Product Transaction Type"

    click_on "Create Product transaction type"

    assert_text "Product transaction type was successfully created"
    click_on "Back"
  end

  test "updating a Product transaction type" do
    visit catalog_product_transaction_types_url
    click_on "Edit", match: :first

    click_on "Update Product transaction type"

    assert_text "Product transaction type was successfully updated"
    click_on "Back"
  end

  test "destroying a Product transaction type" do
    visit catalog_product_transaction_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Product transaction type was successfully destroyed"
  end
end
