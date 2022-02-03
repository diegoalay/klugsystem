class PaymentMethodsController < ApplicationSystemController
  before_action :set_payment_method, only: %i[update destroy]

  # GET /payment_methods or /payment_methods.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.payment_methods)
      end
    end
  end

  # GET /payment_methods/1 or /payment_methods/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_payment_method

        respond_with_successful(@payment_method)
      end
    end
  end

  # GET /payment_methods/new
  def new
  end

  # GET /payment_methods/1/edit
  def edit
  end

  # POST /payment_methods or /payment_methods.json
  def create
    @payment_method = @account.payment_methods.new(payment_method_params)
    @payment_method.user_creator = current_user
    @payment_method.user_modifier = current_user

    if @payment_method.save
      respond_with_successful(@payment_method)
    else
      respond_payment_method_with_error
    end
  end

  # PATCH/PUT /payment_methods/1 or /payment_methods/1.json
  def update
    @payment_method.user_modifier = current_user

    if @payment_method.update(payment_method_params)
      respond_with_successful(@payment_method)
    else
      respond_payment_method_with_error
    end
  end

  # DELETE /payment_methods/1 or /payment_methods/1.json
  def destroy
    @payment_method.user_modifier = current_user

    if @payment_method.destroy
      respond_with_successful(@payment_method)
    else
      respond_payment_method_with_error
    end
  end

  def search
    respond_with_successful(PaymentMethod.search(@account, @query))
  end

  def options
    respond_with_successful(PaymentMethod.options(@account))
  end

  private

  def respond_payment_method_with_error
    return respond_with_error(@payment_method.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_payment_method
    @payment_method = @account.payment_methods.find_by(id: params[:id])

    return respond_with_not_found unless @payment_method
  end

  # Only allow a list of trusted parameters through.
  def payment_method_params
    params.fetch(:payment_method, {}).permit(
      %i[
        name
        interest_value
        interest_percentage
        status
      ]
    )
  end
end