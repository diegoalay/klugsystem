class Catalog::EventTypesController < ApplicationController
  before_action :set_catalog_event_type, only: %i[ show edit update destroy ]

  # GET /catalog/event_types or /catalog/event_types.json
  def index
    @catalog_event_types = Catalog::EventType.all
  end

  # GET /catalog/event_types/1 or /catalog/event_types/1.json
  def show
  end

  # GET /catalog/event_types/new
  def new
    @catalog_event_type = Catalog::EventType.new
  end

  # GET /catalog/event_types/1/edit
  def edit
  end

  # POST /catalog/event_types or /catalog/event_types.json
  def create
    @catalog_event_type = Catalog::EventType.new(catalog_event_type_params)

    respond_to do |format|
      if @catalog_event_type.save
        format.html { redirect_to @catalog_event_type, notice: "Event type was successfully created." }
        format.json { render :show, status: :created, location: @catalog_event_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @catalog_event_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /catalog/event_types/1 or /catalog/event_types/1.json
  def update
    respond_to do |format|
      if @catalog_event_type.update(catalog_event_type_params)
        format.html { redirect_to @catalog_event_type, notice: "Event type was successfully updated." }
        format.json { render :show, status: :ok, location: @catalog_event_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @catalog_event_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /catalog/event_types/1 or /catalog/event_types/1.json
  def destroy
    @catalog_event_type.destroy
    respond_to do |format|
      format.html { redirect_to catalog_event_types_url, notice: "Event type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_event_type
      @catalog_event_type = Catalog::EventType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_event_type_params
      params.fetch(:catalog_event_type, {})
    end
end
