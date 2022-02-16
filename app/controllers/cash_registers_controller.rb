class CashRegistersController < ApplicationSystemController
  before_action :set_brand, only: %i[update destroy]

  # GET /brands or /brands.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(CashRegister.index(@account, @query))
      end
    end
  end

  # GET /brands/1 or /brands/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_brand

        respond_with_successful(@cash_register)
      end
    end
  end

  # GET /brands/new
  def new
  end

  # GET /brands/1/edit
  def edit
  end

  # POST /brands or /brands.json
  def create
    @cash_register = @account.brands.new(brand_params)
    @cash_register.user_creator = current_user
    @cash_register.user_modifier = current_user

    if @cash_register.save
      respond_with_successful(@cash_register)
    else
      respond_brand_with_error
    end
  end

  # PATCH/PUT /brands/1 or /brands/1.json
  def update
    @cash_register.user_modifier = current_user

    if @cash_register.update(brand_params)
      respond_with_successful(@cash_register)
    else
      respond_brand_with_error
    end
  end

  # DELETE /brands/1 or /brands/1.json
  def destroy
    @cash_register.user_modifier = current_user

    if @cash_register.destroy
      respond_with_successful(@cash_register)
    else
      respond_brand_with_error
    end
  end

  private

  def respond_brand_with_error
    return respond_with_error(@cash_register.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_brand
    @cash_register = @account.brands.find_by(id: params[:id])

    return respond_with_not_found unless @cash_register
  end

  # Only allow a list of trusted parameters through.
  def brand_params
    params.fetch(:cash_register, {}).permit(
      %i[open_date close_date initial_value @]
    )
  end
end