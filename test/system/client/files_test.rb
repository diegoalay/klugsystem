require "application_system_test_case"

class Client::FilesTest < ApplicationSystemTestCase
  setup do
    @client_file = client_files(:one)
  end

  test "visiting the index" do
    visit client_files_url
    assert_selector "h1", text: "Client/Files"
  end

  test "creating a File" do
    visit client_files_url
    click_on "New Client/File"

    click_on "Create File"

    assert_text "File was successfully created"
    click_on "Back"
  end

  test "updating a File" do
    visit client_files_url
    click_on "Edit", match: :first

    click_on "Update File"

    assert_text "File was successfully updated"
    click_on "Back"
  end

  test "destroying a File" do
    visit client_files_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "File was successfully destroyed"
  end
end
