require "test_helper"

class Product::TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_transaction = product_transactions(:one)
  end

  test "should get index" do
    get product_transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_product_transaction_url
    assert_response :success
  end

  test "should create product_transaction" do
    assert_difference('Product::Transaction.count') do
      post product_transactions_url, params: { product_transaction: {  } }
    end

    assert_redirected_to product_transaction_url(Product::Transaction.last)
  end

  test "should show product_transaction" do
    get product_transaction_url(@product_transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_transaction_url(@product_transaction)
    assert_response :success
  end

  test "should update product_transaction" do
    patch product_transaction_url(@product_transaction), params: { product_transaction: {  } }
    assert_redirected_to product_transaction_url(@product_transaction)
  end

  test "should destroy product_transaction" do
    assert_difference('Product::Transaction.count', -1) do
      delete product_transaction_url(@product_transaction)
    end

    assert_redirected_to product_transactions_url
  end
end
