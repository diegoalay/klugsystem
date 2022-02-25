require "test_helper"

class Catalog::ProductTransactionTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_product_transaction_type = catalog_product_transaction_types(:one)
  end

  test "should get index" do
    get catalog_product_transaction_types_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_product_transaction_type_url
    assert_response :success
  end

  test "should create catalog_product_transaction_type" do
    assert_difference('Catalog::ProductTransactionType.count') do
      post catalog_product_transaction_types_url, params: { catalog_product_transaction_type: {  } }
    end

    assert_redirected_to catalog_product_transaction_type_url(Catalog::ProductTransactionType.last)
  end

  test "should show catalog_product_transaction_type" do
    get catalog_product_transaction_type_url(@catalog_product_transaction_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_catalog_product_transaction_type_url(@catalog_product_transaction_type)
    assert_response :success
  end

  test "should update catalog_product_transaction_type" do
    patch catalog_product_transaction_type_url(@catalog_product_transaction_type), params: { catalog_product_transaction_type: {  } }
    assert_redirected_to catalog_product_transaction_type_url(@catalog_product_transaction_type)
  end

  test "should destroy catalog_product_transaction_type" do
    assert_difference('Catalog::ProductTransactionType.count', -1) do
      delete catalog_product_transaction_type_url(@catalog_product_transaction_type)
    end

    assert_redirected_to catalog_product_transaction_types_url
  end
end
