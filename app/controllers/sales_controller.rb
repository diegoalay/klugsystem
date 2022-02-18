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
    @sale.cash_register = current_user.cash_register

    if (params[:sale][:client][:id].blank?)
      create_client

      @sale.client = @new_client
    else
      set_client
    end

    if @sale.save
      products = params[:sale][:products]
      products.each do |product|
        @sale.details.create!(
          account: @account,
          product_id: product["id"],
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

  def index_options
    respond_with_successful(Sale.index_options(@account))
  end

  def options
    respond_with_successful(Sale.options(@account))
  end

  private

  def create_client
    @new_client = @account.clients.create(
      billing_name: params[:sale][:client][:billing_name],
      billing_address: params[:sale][:client][:billing_address],
      billing_email: params[:sale][:client][:billing_email],
      billing_identifier: params[:sale][:client][:billing_identifier],
      user_creator: current_user
    )
  end

  def set_client
    @account.clients.find_by(id: params[:sale][:client][:id]).update(
      billing_name: params[:sale][:client][:billing_name],
      billing_address: params[:sale][:client][:billing_address],
      billing_email: params[:sale][:client][:billing_email],
      user_modifier: current_user
    )
  end

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
        client_id subtotal total discount interest shipping_costs
        received_amount change sale_type employees_id sale_date payment_method_id
      ]
    )
  end
end