class CashRegistersController < ApplicationSystemController
  before_action :set_cash_register, only: %i[update destroy]

  # GET /cash_registers or /cash_registers.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(CashRegister.index(@account, @query))
      end
    end
  end

  # GET /cash_registers/1 or /cash_registers/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_cash_register

        respond_with_successful(@cash_register.show)
      end
    end
  end

  # GET /cash_registers/new
  def new
  end

  # GET /cash_registers/1/edit
  def edit
  end

  # POST /cash_registers or /cash_registers.json
  def create
    @cash_register = @account.cash_registers.new(cash_register_params)
    @cash_register.user_creator = current_user
    @cash_register.user_modifier = current_user
    @cash_register.open_date = Time.current

    if @cash_register.save
      respond_with_successful(@cash_register.show)
    else
      respond_cash_register_with_error
    end
  end

  # PATCH/PUT /cash_registers/1 or /cash_registers/1.json
  def update
    @cash_register.user_modifier = current_user

    if params[:cash_register][:close]
        @cash_register.close_date = Time.current
        @cash_register.final_value = @cash_register.sum_final_value
    end

    if @cash_register.update(cash_register_params)
      respond_with_successful(@cash_register.show)
    else
      respond_cash_register_with_error
    end
  end

  # DELETE /cash_registers/1 or /cash_registers/1.json
  def destroy
    @cash_register.user_modifier = current_user

    if @cash_register.destroy
      respond_with_successful(@cash_register)
    else
      respond_cash_register_with_error
    end
  end

  private

  def respond_cash_register_with_error
    return respond_with_error(@cash_register.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_cash_register
    @cash_register = @account.cash_registers.find_by(id: params[:id])

    return respond_with_not_found unless @cash_register
  end

  # Only allow a list of trusted parameters through.
  def cash_register_params
    params.fetch(:cash_register, {}).permit(
      %i[initial_value]
    )
  end
end