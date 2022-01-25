class Client::FilesController < ApplicationController
  before_action :set_client_file, only: %i[ show edit update destroy ]

  # GET /client/files or /client/files.json
  def index
    @client_files = Client::File.all
  end

  # GET /client/files/1 or /client/files/1.json
  def show
  end

  # GET /client/files/new
  def new
    @client_file = Client::File.new
  end

  # GET /client/files/1/edit
  def edit
  end

  # POST /client/files or /client/files.json
  def create
    @client_file = Client::File.new(client_file_params)

    respond_to do |format|
      if @client_file.save
        format.html { redirect_to @client_file, notice: "File was successfully created." }
        format.json { render :show, status: :created, location: @client_file }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /client/files/1 or /client/files/1.json
  def update
    respond_to do |format|
      if @client_file.update(client_file_params)
        format.html { redirect_to @client_file, notice: "File was successfully updated." }
        format.json { render :show, status: :ok, location: @client_file }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /client/files/1 or /client/files/1.json
  def destroy
    @client_file.destroy
    respond_to do |format|
      format.html { redirect_to client_files_url, notice: "File was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client_file
      @client_file = Client::File.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_file_params
      params.fetch(:client_file, {})
    end
end
