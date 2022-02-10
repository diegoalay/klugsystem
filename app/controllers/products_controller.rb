class ProductsController < ApplicationSystemController
  before_action :set_product, only: %i[update destroy]

  # GET /products or /products.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(Product.index(@account, @query))
      end
    end
  end

  # GET /products/1 or /products/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_product

        respond_with_successful(@product)
      end
    end
  end

  # GET /products/new
  def new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = @account.products.new(product_params)
    @product.user_creator = current_user
    @product.user_modifier = current_user

    respond_with_error("Debe agregar artículos a la venta.") if params[:products].blank?

    if @product.save
      respond_with_successful(@product)
    else
      respond_product_with_error
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    @product.user_modifier = current_user

    if @product.update(product_params)
      respond_with_successful(@product)
    else
      respond_product_with_error
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.user_modifier = current_user

    if @product.destroy
      respond_with_successful(@product)
    else
      respond_product_with_error
    end
  end

  def search
    respond_with_successful(Product.search(@account, @query))
  end

  def options
    respond_with_successful(Product.options(@account))
  end

  private

  def respond_product_with_error
    return respond_with_error(@product.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = @account.products.find_by(id: params[:id])

    return respond_with_not_found unless @product
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.fetch(:product, {}).permit(
      %i[
        name sku retail_price wholesale_price
        purchase_price quantity note status product_type
        brands_id branch_offices_id items_id departments_id
      ]
    )
  end
end