require "test_helper"

class Client::FilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client_file = client_files(:one)
  end

  test "should get index" do
    get client_files_url
    assert_response :success
  end

  test "should get new" do
    get new_client_file_url
    assert_response :success
  end

  test "should create client_file" do
    assert_difference('Client::File.count') do
      post client_files_url, params: { client_file: {  } }
    end

    assert_redirected_to client_file_url(Client::File.last)
  end

  test "should show client_file" do
    get client_file_url(@client_file)
    assert_response :success
  end

  test "should get edit" do
    get edit_client_file_url(@client_file)
    assert_response :success
  end

  test "should update client_file" do
    patch client_file_url(@client_file), params: { client_file: {  } }
    assert_redirected_to client_file_url(@client_file)
  end

  test "should destroy client_file" do
    assert_difference('Client::File.count', -1) do
      delete client_file_url(@client_file)
    end

    assert_redirected_to client_files_url
  end
end
