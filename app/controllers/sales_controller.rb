class SalesController < ApplicationSystemController
  before_action :set_sale, only: %i[update destroy]

  # GET /sales or /sales.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(Finance::SaleQuery.new(@account).index(current_user, @query))
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
      format.pdf do
        set_sale

        @details = @sale.show
        render template: 'sales/show.pdf.html.erb', viewport_size: '1280x1024', pdf: "VENTA: #{@details[:sale].dig('id')}"
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
      sale_products = params[:sale][:products]

      ActiveRecord::Base.transaction do
        sale_products.each do |sale_product|
          sale_detail = @sale.details.new(
            account: @account,
            product_id: sale_product["id"],
            name: sale_product["name"],
            price: sale_product["price"],
            total: sale_product["total"],
            quantity: sale_product["quantity"],
            subtotal: sale_product["subtotal"],
            discount_value: sale_product["discount_value"],
            discount_percentage: sale_product["discount_percentage"]
          )

          if (sale_detail.save!)
            product = @account.products.find_by(id: sale_product["id"])

            if (product)
              ActiveRecord::Base.transaction do
                transaction = product.transactions.new(
                  category: "decrease",
                  user_creator: current_user,
                  transaction_type: @account.catalog_product_transaction_sale_type,
                  quantity: sale_product["quantity"],
                  model_id: @sale.id,
                  model_type: "Sale",
                )

                transaction.save!
              end
            end
          end
        end
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
    respond_with_successful(Finance::SaleQuery.new(@account).index_options)
  end

  def options
    respond_with_successful(Finance::SaleQuery.new(@account).options)
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