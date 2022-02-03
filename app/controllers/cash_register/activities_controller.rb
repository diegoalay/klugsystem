class CashRegister::ActivitiesController < ApplicationController
  before_action :set_cash_register_activity, only: %i[ show edit update destroy ]

  # GET /cash_register/activities or /cash_register/activities.json
  def index
    @cash_register_activities = CashRegister::Activity.all
  end

  # GET /cash_register/activities/1 or /cash_register/activities/1.json
  def show
  end

  # GET /cash_register/activities/new
  def new
    @cash_register_activity = CashRegister::Activity.new
  end

  # GET /cash_register/activities/1/edit
  def edit
  end

  # POST /cash_register/activities or /cash_register/activities.json
  def create
    @cash_register_activity = CashRegister::Activity.new(cash_register_activity_params)

    respond_to do |format|
      if @cash_register_activity.save
        format.html { redirect_to @cash_register_activity, notice: "Activity was successfully created." }
        format.json { render :show, status: :created, location: @cash_register_activity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cash_register_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cash_register/activities/1 or /cash_register/activities/1.json
  def update
    respond_to do |format|
      if @cash_register_activity.update(cash_register_activity_params)
        format.html { redirect_to @cash_register_activity, notice: "Activity was successfully updated." }
        format.json { render :show, status: :ok, location: @cash_register_activity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cash_register_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cash_register/activities/1 or /cash_register/activities/1.json
  def destroy
    @cash_register_activity.destroy
    respond_to do |format|
      format.html { redirect_to cash_register_activities_url, notice: "Activity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cash_register_activity
      @cash_register_activity = CashRegister::Activity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cash_register_activity_params
      params.fetch(:cash_register_activity, {})
    end
end
