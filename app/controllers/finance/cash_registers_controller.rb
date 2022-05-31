class Finance::CashRegistersController < ::CashRegistersController
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
