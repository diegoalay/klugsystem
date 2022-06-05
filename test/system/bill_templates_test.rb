require "application_system_test_case"

class BillTemplatesTest < ApplicationSystemTestCase
  setup do
    @bill_template = bill_templates(:one)
  end

  test "visiting the index" do
    visit bill_templates_url
    assert_selector "h1", text: "Bill Templates"
  end

  test "creating a Bill template" do
    visit bill_templates_url
    click_on "New Bill Template"

    click_on "Create Bill template"

    assert_text "Bill template was successfully created"
    click_on "Back"
  end

  test "updating a Bill template" do
    visit bill_templates_url
    click_on "Edit", match: :first

    click_on "Update Bill template"

    assert_text "Bill template was successfully updated"
    click_on "Back"
  end

  test "destroying a Bill template" do
    visit bill_templates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Bill template was successfully destroyed"
  end
end
