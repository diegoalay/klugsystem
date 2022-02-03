class CashRegistersController < ApplicationController
  before_action :set_cash_register, only: %i[ show edit update destroy ]

  # GET /cash_registers or /cash_registers.json
  def index
    @cash_registers = CashRegister.all
  end

  # GET /cash_registers/1 or /cash_registers/1.json
  def show
  end

  # GET /cash_registers/new
  def new
    @cash_register = CashRegister.new
  end

  # GET /cash_registers/1/edit
  def edit
  end

  # POST /cash_registers or /cash_registers.json
  def create
    @cash_register = CashRegister.new(cash_register_params)

    respond_to do |format|
      if @cash_register.save
        format.html { redirect_to @cash_register, notice: "Cash register was successfully created." }
        format.json { render :show, status: :created, location: @cash_register }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cash_register.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cash_registers/1 or /cash_registers/1.json
  def update
    respond_to do |format|
      if @cash_register.update(cash_register_params)
        format.html { redirect_to @cash_register, notice: "Cash register was successfully updated." }
        format.json { render :show, status: :ok, location: @cash_register }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cash_register.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cash_registers/1 or /cash_registers/1.json
  def destroy
    @cash_register.destroy
    respond_to do |format|
      format.html { redirect_to cash_registers_url, notice: "Cash register was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cash_register
      @cash_register = CashRegister.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cash_register_params
      params.fetch(:cash_register, {})
    end
end
