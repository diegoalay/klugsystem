require "test_helper"

class BillTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bill_template = bill_templates(:one)
  end

  test "should get index" do
    get bill_templates_url
    assert_response :success
  end

  test "should get new" do
    get new_bill_template_url
    assert_response :success
  end

  test "should create bill_template" do
    assert_difference('BillTemplate.count') do
      post bill_templates_url, params: { bill_template: {  } }
    end

    assert_redirected_to bill_template_url(BillTemplate.last)
  end

  test "should show bill_template" do
    get bill_template_url(@bill_template)
    assert_response :success
  end

  test "should get edit" do
    get edit_bill_template_url(@bill_template)
    assert_response :success
  end

  test "should update bill_template" do
    patch bill_template_url(@bill_template), params: { bill_template: {  } }
    assert_redirected_to bill_template_url(@bill_template)
  end

  test "should destroy bill_template" do
    assert_difference('BillTemplate.count', -1) do
      delete bill_template_url(@bill_template)
    end

    assert_redirected_to bill_templates_url
  end
end
