
class Product::TransactionsController < ApplicationSystemController
  before_action :set_product, only: %i[index create]

  # GET /transactions or /transactions.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(Product::Transaction.index(@account, @product, @query))
      end
    end
  end

  # POST /transactions or /transactions.json
  def create
    @product_transaction = @product.transactions.new(product_transaction_params)
    @product_transaction.user_creator = current_user

    if @product_transaction.save
      respond_with_successful(@product_transaction)
    else
      respond_product_transaction_with_error
    end
  end

  def options
    respond_with_successful(Product::Transaction.options(@account))
  end

  private

  def respond_product_transaction_with_error
    return respond_with_error(@product_transaction.errors.full_messages.to_sentence)
  end

  def set_product
    @product = @account.products.find_by(id: params[:product_id])
  end

  # Only allow a list of trusted parameters through.
  def product_transaction_params
    params.fetch(:product_transaction, {}).permit(
      %i[quantity product_transaction_type_id description category]
    )
  end
end