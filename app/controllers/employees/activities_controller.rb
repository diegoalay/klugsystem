class Employees::ActivitiesController < ApplicationController
  before_action :set_employees_activity, only: %i[ show edit update destroy ]

  # GET /employees/activities or /employees/activities.json
  def index
    @employees_activities = Employees::Activity.all
  end

  # GET /employees/activities/1 or /employees/activities/1.json
  def show
  end

  # GET /employees/activities/new
  def new
    @employees_activity = Employees::Activity.new
  end

  # GET /employees/activities/1/edit
  def edit
  end

  # POST /employees/activities or /employees/activities.json
  def create
    @employees_activity = Employees::Activity.new(employees_activity_params)

    respond_to do |format|
      if @employees_activity.save
        format.html { redirect_to @employees_activity, notice: "Activity was successfully created." }
        format.json { render :show, status: :created, location: @employees_activity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @employees_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/activities/1 or /employees/activities/1.json
  def update
    respond_to do |format|
      if @employees_activity.update(employees_activity_params)
        format.html { redirect_to @employees_activity, notice: "Activity was successfully updated." }
        format.json { render :show, status: :ok, location: @employees_activity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @employees_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/activities/1 or /employees/activities/1.json
  def destroy
    @employees_activity.destroy
    respond_to do |format|
      format.html { redirect_to employees_activities_url, notice: "Activity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employees_activity
      @employees_activity = Employees::Activity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def employees_activity_params
      params.fetch(:employees_activity, {})
    end
end
