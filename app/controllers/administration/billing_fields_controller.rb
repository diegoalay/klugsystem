class Administration::BillingFieldsController < ApplicationSystemController
  before_action :set_billing_field, only: %i[update destroy]

  # GET /billing_fields or /billing_fields.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.billing_fields)
      end
    end
  end

  # GET /billing_fields/1 or /billing_fields/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_billing_field

        respond_with_successful(@billing_field)
      end
    end
  end

  # GET /billing_fields/new
  def new
  end

  # GET /billing_fields/1/edit
  def edit
  end

  # POST /billing_fields or /billing_fields.json
  def create
    @billing_field = @account.billing_fields.new(billing_field_params)
    @billing_field.user_creator = current_user
    @billing_field.user_modifier = current_user

    if @billing_field.save
      respond_with_successful(@billing_field)
    else
      respond_billing_field_with_error
    end
  end

  # PATCH/PUT /billing_fields/1 or /billing_fields/1.json
  def update
    @billing_field.user_modifier = current_user

    if @billing_field.update(billing_field_params)
      respond_with_successful(@billing_field)
    else
      respond_billing_field_with_error
    end
  end

  # DELETE /billing_fields/1 or /billing_fields/1.json
  def destroy
    @billing_field.user_modifier = current_user

    if @billing_field.destroy
      respond_with_successful(@billing_field)
    else
      respond_billing_field_with_error
    end
  end

  private

  def respond_billing_field_with_error
    return respond_with_error(@billing_field.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_billing_field
    @billing_field = @account.billing_fields.find_by(id: params[:id])

    return respond_with_not_found unless @billing_field
  end

  # Only allow a list of trusted parameters through.
  def billing_field_params
    params.fetch(:billing_field, {}).permit(
      %i[title type value color position_x position_y settings]
    )
  end
end