require "test_helper"

class Provider::ContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider_contact = provider_contacts(:one)
  end

  test "should get index" do
    get provider_contacts_url
    assert_response :success
  end

  test "should get new" do
    get new_provider_contact_url
    assert_response :success
  end

  test "should create provider_contact" do
    assert_difference('Provider::Contact.count') do
      post provider_contacts_url, params: { provider_contact: {  } }
    end

    assert_redirected_to provider_contact_url(Provider::Contact.last)
  end

  test "should show provider_contact" do
    get provider_contact_url(@provider_contact)
    assert_response :success
  end

  test "should get edit" do
    get edit_provider_contact_url(@provider_contact)
    assert_response :success
  end

  test "should update provider_contact" do
    patch provider_contact_url(@provider_contact), params: { provider_contact: {  } }
    assert_redirected_to provider_contact_url(@provider_contact)
  end

  test "should destroy provider_contact" do
    assert_difference('Provider::Contact.count', -1) do
      delete provider_contact_url(@provider_contact)
    end

    assert_redirected_to provider_contacts_url
  end
end
