class Catalog::ProductTransactionTypesController < ApplicationSystemController
  before_action :set_catalog_product_transaction_type, only: %i[update destroy]

  # GET /catalog_product_transaction_types or /catalog_product_transaction_types.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.catalog_product_transaction_types)
      end
    end
  end

  # GET /catalog_product_transaction_types/1 or /catalog_product_transaction_types/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_catalog_product_transaction_type

        respond_with_successful(@catalog_product_transaction_type)
      end
    end
  end

  # GET /catalog_product_transaction_types/new
  def new
  end

  # GET /catalog_product_transaction_types/1/edit
  def edit
  end

  # POST /catalog_product_transaction_types or /catalog_product_transaction_types.json
  def create
    @catalog_product_transaction_type = @account.catalog_product_transaction_types.new(catalog_product_transaction_type_params)
    @catalog_product_transaction_type.user_creator = current_user
    @catalog_product_transaction_type.user_modifier = current_user

    if @catalog_product_transaction_type.save
      respond_with_successful(@catalog_product_transaction_type)
    else
      respond_catalog_product_transaction_type_with_error
    end
  end

  # PATCH/PUT /catalog_product_transaction_types/1 or /catalog_product_transaction_types/1.json
  def update
    @catalog_product_transaction_type.user_modifier = current_user

    if @catalog_product_transaction_type.update(catalog_product_transaction_type_params)
      respond_with_successful(@catalog_product_transaction_type)
    else
      respond_catalog_product_transaction_type_with_error
    end
  end

  # DELETE /catalog_product_transaction_types/1 or /catalog_product_transaction_types/1.json
  def destroy
    @catalog_product_transaction_type.user_modifier = current_user

    if @catalog_product_transaction_type.destroy
      respond_with_successful(@catalog_product_transaction_type)
    else
      respond_catalog_product_transaction_type_with_error
    end
  end

  private

  def respond_catalog_product_transaction_type_with_error
    return respond_with_error(@catalog_product_transaction_type.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_catalog_product_transaction_type
    @catalog_product_transaction_type = @account.catalog_product_transaction_types.find_by(id: params[:id])

    return respond_with_not_found unless @catalog_product_transaction_type
  end

  # Only allow a list of trusted parameters through.
  def catalog_product_transaction_type_params
    params.fetch(:catalog_product_transaction_type, {}).permit(
      %i[name note]
    )
  end
end