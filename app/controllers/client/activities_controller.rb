class Client::ActivitiesController < ApplicationController
  before_action :set_client_activity, only: %i[ show edit update destroy ]

  # GET /client/activities or /client/activities.json
  def index
    @client_activities = Client::Activity.all
  end

  # GET /client/activities/1 or /client/activities/1.json
  def show
  end

  # GET /client/activities/new
  def new
    @client_activity = Client::Activity.new
  end

  # GET /client/activities/1/edit
  def edit
  end

  # POST /client/activities or /client/activities.json
  def create
    @client_activity = Client::Activity.new(client_activity_params)

    respond_to do |format|
      if @client_activity.save
        format.html { redirect_to @client_activity, notice: "Activity was successfully created." }
        format.json { render :show, status: :created, location: @client_activity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /client/activities/1 or /client/activities/1.json
  def update
    respond_to do |format|
      if @client_activity.update(client_activity_params)
        format.html { redirect_to @client_activity, notice: "Activity was successfully updated." }
        format.json { render :show, status: :ok, location: @client_activity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /client/activities/1 or /client/activities/1.json
  def destroy
    @client_activity.destroy
    respond_to do |format|
      format.html { redirect_to client_activities_url, notice: "Activity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client_activity
      @client_activity = Client::Activity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_activity_params
      params.fetch(:client_activity, {})
    end
end
