class Configuration::ProductTransactionTypesController < ApplicationSystemController
  before_action :set_product_transaction_type, only: %i[update destroy]

  # GET /product_transaction_types or /product_transaction_types.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.product_transaction_types)
      end
    end
  end

  # GET /product_transaction_types/1 or /product_transaction_types/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_product_transaction_type

        respond_with_successful(@product_transaction_type)
      end
    end
  end

  # GET /product_transaction_types/new
  def new
  end

  # GET /product_transaction_types/1/edit
  def edit
  end

  # POST /product_transaction_types or /product_transaction_types.json
  def create
    @product_transaction_type = @account.product_transaction_types.new(product_transaction_type_params)
    @product_transaction_type.user_creator = current_user
    @product_transaction_type.user_modifier = current_user

    if @product_transaction_type.save
      respond_with_successful(@product_transaction_type)
    else
      respond_product_transaction_type_with_error
    end
  end

  # PATCH/PUT /product_transaction_types/1 or /product_transaction_types/1.json
  def update
    @product_transaction_type.user_modifier = current_user

    if @product_transaction_type.update(product_transaction_type_params)
      respond_with_successful(@product_transaction_type)
    else
      respond_product_transaction_type_with_error
    end
  end

  # DELETE /product_transaction_types/1 or /product_transaction_types/1.json
  def destroy
    @product_transaction_type.user_modifier = current_user

    if @product_transaction_type.destroy
      respond_with_successful(@product_transaction_type)
    else
      respond_product_transaction_type_with_error
    end
  end

  private

  def respond_product_transaction_type_with_error
    return respond_with_error(@product_transaction_type.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_product_transaction_type
    @product_transaction_type = @account.product_transaction_types.find_by(id: params[:id])

    return respond_with_not_found unless @product_transaction_type
  end

  # Only allow a list of trusted parameters through.
  def product_transaction_type_params
    params.fetch(:product_transaction_type, {}).permit(
      %i[name note]
    )
  end
end