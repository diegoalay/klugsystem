class ExpedituresController < ApplicationController
  before_action :set_expediture, only: %i[ show edit update destroy ]

  # GET /expeditures or /expeditures.json
  def index
    @expeditures = Expediture.all
  end

  # GET /expeditures/1 or /expeditures/1.json
  def show
  end

  # GET /expeditures/new
  def new
    @expediture = Expediture.new
  end

  # GET /expeditures/1/edit
  def edit
  end

  # POST /expeditures or /expeditures.json
  def create
    @expediture = Expediture.new(expediture_params)

    respond_to do |format|
      if @expediture.save
        format.html { redirect_to expediture_url(@expediture), notice: "Expediture was successfully created." }
        format.json { render :show, status: :created, location: @expediture }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expediture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expeditures/1 or /expeditures/1.json
  def update
    respond_to do |format|
      if @expediture.update(expediture_params)
        format.html { redirect_to expediture_url(@expediture), notice: "Expediture was successfully updated." }
        format.json { render :show, status: :ok, location: @expediture }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expediture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expeditures/1 or /expeditures/1.json
  def destroy
    @expediture.destroy

    respond_to do |format|
      format.html { redirect_to expeditures_url, notice: "Expediture was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expediture
      @expediture = Expediture.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def expediture_params
      params.fetch(:expediture, {})
    end
end
