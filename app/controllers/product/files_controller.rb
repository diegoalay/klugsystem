class Product::FilesController < ApplicationController
  before_action :set_product_file, only: %i[ show edit update destroy ]

  # GET /product/files or /product/files.json
  def index
    @product_files = Product::File.all
  end

  # GET /product/files/1 or /product/files/1.json
  def show
  end

  # GET /product/files/new
  def new
    @product_file = Product::File.new
  end

  # GET /product/files/1/edit
  def edit
  end

  # POST /product/files or /product/files.json
  def create
    @product_file = Product::File.new(product_file_params)

    respond_to do |format|
      if @product_file.save
        format.html { redirect_to @product_file, notice: "File was successfully created." }
        format.json { render :show, status: :created, location: @product_file }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product/files/1 or /product/files/1.json
  def update
    respond_to do |format|
      if @product_file.update(product_file_params)
        format.html { redirect_to @product_file, notice: "File was successfully updated." }
        format.json { render :show, status: :ok, location: @product_file }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product/files/1 or /product/files/1.json
  def destroy
    @product_file.destroy
    respond_to do |format|
      format.html { redirect_to product_files_url, notice: "File was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_file
      @product_file = Product::File.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_file_params
      params.fetch(:product_file, {})
    end
end
