class QuotationsController < ApplicationSystemController
  before_action :set_quotation, only: %i[update destroy]

  # GET /quotations or /quotations.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(Quotation.index(@account, current_user, @query))
      end
    end
  end

  # GET /quotations/1 or /quotations/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_quotation

        respond_with_successful(@quotation.show)
      end
    end
  end

  # GET /quotations/new
  def new
  end

  # GET /quotations/1/edit
  def edit
  end

  # POST /quotations or /quotations.json
  def create
    @quotation = @account.quotations.new(quotation_params)
    @quotation.user_creator = current_user
    @quotation.user_modifier = current_user

    if (params[:quotation][:client][:id].blank?)
      create_client

      @quotation.client = @new_client
    else
      set_client
    end

    if @quotation.save
      AppServices::QuotationService.new(@sale, params[:quotation][:products], current_user).call
      respond_with_successful(@quotation)
    else
      respond_quotation_with_error
    end
  end

  # PATCH/PUT /quotations/1 or /quotations/1.json
  def update
    @quotation.user_modifier = current_user

    if @quotation.update(quotation_params)
      respond_with_successful(@quotation)
    else
      respond_quotation_with_error
    end
  end

  # DELETE /quotations/1 or /quotations/1.json
  def destroy
    @quotation.user_modifier = current_user

    if @quotation.destroy
      respond_with_successful(@quotation)
    else
      respond_quotation_with_error
    end
  end

  def index_options
    respond_with_successful(Finance::QuotationQuery.new(@account).index_options)
  end

  def options
    respond_with_successful(Finance::QuotationQuery.new(@account).options)
  end

  private

  def create_client
    @new_client = @account.clients.create(
      billing_name: params[:quotation][:client][:billing_name],
      billing_address: params[:quotation][:client][:billing_address],
      billing_email: params[:quotation][:client][:billing_email],
      billing_identifier: params[:quotation][:client][:billing_identifier],
      user_creator: current_user
    )
  end

  def set_client
    @account.clients.find_by(id: params[:quotation][:client][:id]).update(
      billing_name: params[:quotation][:client][:billing_name],
      billing_address: params[:quotation][:client][:billing_address],
      billing_email: params[:quotation][:client][:billing_email],
      user_modifier: current_user
    )
  end

  def respond_quotation_with_error
    return respond_with_error(@quotation.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_quotation
    @quotation = @account.quotations.find_by(id: params[:id])

    return respond_with_not_found unless @quotation
  end

  # Only allow a list of trusted parameters through.
  def quotation_params
    params.fetch(:quotation, {}).permit(
      %i[
        subtotal total discount interest shipping_costs
        received_amount change quotation_type employees_id quotation_date payment_method_id
      ]
    )
  end
end