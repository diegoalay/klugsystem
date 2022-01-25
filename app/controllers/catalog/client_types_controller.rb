class Catalog::ClientTypesController < ApplicationController
  before_action :set_catalog_client_type, only: %i[ show edit update destroy ]

  # GET /catalog/client_types or /catalog/client_types.json
  def index
    @catalog_client_types = Catalog::ClientType.all
  end

  # GET /catalog/client_types/1 or /catalog/client_types/1.json
  def show
  end

  # GET /catalog/client_types/new
  def new
    @catalog_client_type = Catalog::ClientType.new
  end

  # GET /catalog/client_types/1/edit
  def edit
  end

  # POST /catalog/client_types or /catalog/client_types.json
  def create
    @catalog_client_type = Catalog::ClientType.new(catalog_client_type_params)

    respond_to do |format|
      if @catalog_client_type.save
        format.html { redirect_to @catalog_client_type, notice: "Client type was successfully created." }
        format.json { render :show, status: :created, location: @catalog_client_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @catalog_client_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /catalog/client_types/1 or /catalog/client_types/1.json
  def update
    respond_to do |format|
      if @catalog_client_type.update(catalog_client_type_params)
        format.html { redirect_to @catalog_client_type, notice: "Client type was successfully updated." }
        format.json { render :show, status: :ok, location: @catalog_client_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @catalog_client_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /catalog/client_types/1 or /catalog/client_types/1.json
  def destroy
    @catalog_client_type.destroy
    respond_to do |format|
      format.html { redirect_to catalog_client_types_url, notice: "Client type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog_client_type
      @catalog_client_type = Catalog::ClientType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def catalog_client_type_params
      params.fetch(:catalog_client_type, {})
    end
end
