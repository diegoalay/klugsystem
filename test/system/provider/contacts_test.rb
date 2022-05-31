require "application_system_test_case"

class Provider::ContactsTest < ApplicationSystemTestCase
  setup do
    @provider_contact = provider_contacts(:one)
  end

  test "visiting the index" do
    visit provider_contacts_url
    assert_selector "h1", text: "Provider/Contacts"
  end

  test "creating a Contact" do
    visit provider_contacts_url
    click_on "New Provider/Contact"

    click_on "Create Contact"

    assert_text "Contact was successfully created"
    click_on "Back"
  end

  test "updating a Contact" do
    visit provider_contacts_url
    click_on "Edit", match: :first

    click_on "Update Contact"

    assert_text "Contact was successfully updated"
    click_on "Back"
  end

  test "destroying a Contact" do
    visit provider_contacts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Contact was successfully destroyed"
  end
end
