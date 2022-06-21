class SalesController < ApplicationSystemController
  before_action :set_sale, only: %i[update destroy send_sale emails_sent]

  require 'prawn'

  # GET /sales or /sales.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(SaleQuery.new(@account).index(current_user, @query))
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

        if @sale.electronic_bill.present? && @sale.electronic_bill.identifier
          attachment = DigifactServices::Api.new(current_user, @sale).download['ResponseDATA3']
          decode_base64_content = Base64.decode64(attachment)

          pdf = DocumentGeneratorServices::PdfService.new(@sale).call

          fragua_details = CombinePDF.parse(pdf.render).pages[0]
          final_pdf = CombinePDF.parse(decode_base64_content)
          final_pdf.pages.each { |page| page << fragua_details }

          send_data final_pdf.to_pdf, filename: "Factura.pdf", type: "application/pdf"
        else
          @details = @sale.show
          render template: 'sales/show.pdf.html.erb', viewport_size: '1280x1024', pdf: "VENTA: #{@details[:sale].dig('id')}"
        end
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
    @sale.cash_register = current_user.current_cash_register if params[:sale][:cash_register]
    @sale.branch_office = current_user.branch_office

    if (params[:sale][:client][:id].blank?)
      create_client

      @sale.client = @new_client

      unless @new_client.save
        return respond_with_error('Debe completar el número de nit, dirección y nombre del cliente.')
      end
    else
      set_client
    end

    if @sale.save
      AppServices::SaleService.new(@sale, params[:sale][:products], current_user).call

      if @sale.electronic_bill?
        DigifactServices::Api.new(current_user, @sale).generate_bill

        if (@sale.electronic_bill.identifier.blank?)
          @sale.destroy!

          return respond_with_error(@sale.electronic_bill['certification_data']["ResponseDATA1"])
        else
          SaleMailer.send_sale(@sale, current_user, params[:sale][:client][:billing_email]).deliver_later
        end
      end

      respond_with_successful(@sale)

      if (@sale.origin != 'bill')
        @sale.details.each do |sale_detail|
          product = @current_user.account.products.find_by(id: sale_detail.product_id)

          if (product && product.good?)
            ActiveRecord::Base.transaction do
              transaction = product.transactions.new(
                category: "decrease",
                user_creator: @current_user,
                transaction_type: @current_user.account.product_transaction_sale_type,
                quantity: sale_detail.quantity,
                model_id: @sale.id,
                model_type: "Sale",
              )

              transaction.save!
            end
          end
        end
      end
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

  def emails_sent
    respond_with_successful(@sale.activities.where(category: 'sale_sent'))
  end

  def send_sale
    SaleMailer.send_sale(@sale, current_user, params[:client][:email]).deliver_now

    respond_with_successful
  end

  def options
    respond_with_successful(SaleQuery.new(@account).options(current_user, @query))
  end

  private

  def create_client
    billing_identifier = params[:sale][:client][:billing_identifier]&.gsub("-", "")&.gsub(/\s/, "")&.upcase

    @new_client = @account.clients.find_or_initialize_by(
      billing_identifier: billing_identifier
    )

    @new_client.assign_attributes(
      billing_name: params[:sale][:client][:billing_name],
      billing_address: params[:sale][:client][:billing_address],
      billing_email: billing_identifier == 'CF' ? nil : params[:sale][:client][:billing_email],
      user_creator: current_user
    )
  end

  def set_client
    client = @account.clients.find_by(id: params[:sale][:client][:id])


    unless client.billing_identifier == 'CF'
      client.update(
        billing_name: params[:sale][:client][:billing_name],
        billing_address: params[:sale][:client][:billing_address],
        billing_email: params[:sale][:client][:billing_email],
        user_modifier: current_user
      )
    end

    client
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
      :origin,
      :client_id,
      :subtotal,
      :subtotal1,
      :subtotal2,
      :total,
      :discount,
      :interest,
      :shipping_costs,
      :status,
      :received_amount,
      :change,
      :sale_type,
      :employees_id,
      :sale_date,
      :payment_method_id,
      custom_fields: [
        :id,
        :value,
        :title,
        :visible
      ]
    )
  end
end