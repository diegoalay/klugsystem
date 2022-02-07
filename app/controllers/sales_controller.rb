class SalesController < ApplicationSystemController
  before_action :set_sale, only: %i[update destroy]

  # GET /sales or /sales.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(Sale.index(@account, @query))
      end
    end
  end

  # GET /sales/1 or /sales/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_sale

        respond_with_successful(@sale.show)
      end
    end
  end

  # GET /sales/new
  def new
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales or /sales.json
  def create
    @sale = @account.sales.new(sale_params)
    @sale.user_creator = current_user
    @sale.user_modifier = current_user

    if @sale.save
      products = params[:sale][:products]
      products.each do |product|
        @sale.details.create!(
          account: @account,
          products_id: product["id"],
          name: product["name"],
          price: product["price"],
          total: product["total"],
          quantity: product["quantity"],
          subtotal: product["subtotal"],
          discount_value: product["discount_value"],
          discount_percentage: product["discount_percentage"]
        )
      end
      respond_with_successful(@sale)
    else
      respond_sale_with_error
    end
  end

  # PATCH/PUT /sales/1 or /sales/1.json
  def update
    @sale.user_modifier = current_user

    if @sale.update(sale_params)
      respond_with_successful(@sale)
    else
      respond_sale_with_error
    end
  end

  # DELETE /sales/1 or /sales/1.json
  def destroy
    @sale.user_modifier = current_user

    if @sale.destroy
      respond_with_successful(@sale)
    else
      respond_sale_with_error
    end
  end

  def options
    respond_with_successful(Sale.options(@account))
  end

  private

  def respond_sale_with_error
    return respond_with_error(@sale.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_sale
    @sale = @account.sales.find_by(id: params[:id])

    return respond_with_not_found unless @sale
  end

  # Only allow a list of trusted parameters through.
  def sale_params
    params.fetch(:sale, {}).permit(
      %i[
        clients_id subtotal total discount interest shipping_costs
        received_amount change sale_type employees_id sale_date
      ]
    )
  end
end