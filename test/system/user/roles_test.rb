require "application_system_test_case"

class User::RolesTest < ApplicationSystemTestCase
  setup do
    @user_role = user_roles(:one)
  end

  test "visiting the index" do
    visit user_roles_url
    assert_selector "h1", text: "User/Roles"
  end

  test "creating a Role" do
    visit user_roles_url
    click_on "New User/Role"

    click_on "Create Role"

    assert_text "Role was successfully created"
    click_on "Back"
  end

  test "updating a Role" do
    visit user_roles_url
    click_on "Edit", match: :first

    click_on "Update Role"

    assert_text "Role was successfully updated"
    click_on "Back"
  end

  test "destroying a Role" do
    visit user_roles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Role was successfully destroyed"
  end
end
