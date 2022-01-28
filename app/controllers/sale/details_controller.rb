class Sale::DetailsController < ApplicationController
  before_action :set_sale_detail, only: %i[ show edit update destroy ]

  # GET /sale/details or /sale/details.json
  def index
    @sale_details = Sale::Detail.all
  end

  # GET /sale/details/1 or /sale/details/1.json
  def show
  end

  # GET /sale/details/new
  def new
    @sale_detail = Sale::Detail.new
  end

  # GET /sale/details/1/edit
  def edit
  end

  # POST /sale/details or /sale/details.json
  def create
    @sale_detail = Sale::Detail.new(sale_detail_params)

    respond_to do |format|
      if @sale_detail.save
        format.html { redirect_to @sale_detail, notice: "Detail was successfully created." }
        format.json { render :show, status: :created, location: @sale_detail }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sale/details/1 or /sale/details/1.json
  def update
    respond_to do |format|
      if @sale_detail.update(sale_detail_params)
        format.html { redirect_to @sale_detail, notice: "Detail was successfully updated." }
        format.json { render :show, status: :ok, location: @sale_detail }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sale_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sale/details/1 or /sale/details/1.json
  def destroy
    @sale_detail.destroy
    respond_to do |format|
      format.html { redirect_to sale_details_url, notice: "Detail was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale_detail
      @sale_detail = Sale::Detail.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sale_detail_params
      params.fetch(:sale_detail, {})
    end
end
