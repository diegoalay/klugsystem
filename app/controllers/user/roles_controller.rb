class User::RolesController < ApplicationController
  before_action :set_user_role, only: %i[ show edit update destroy ]

  # GET /user/roles or /user/roles.json
  def index
    @user_roles = User::Role.all
  end

  # GET /user/roles/1 or /user/roles/1.json
  def show
  end

  # GET /user/roles/new
  def new
    @user_role = User::Role.new
  end

  # GET /user/roles/1/edit
  def edit
  end

  # POST /user/roles or /user/roles.json
  def create
    @user_role = User::Role.new(user_role_params)

    respond_to do |format|
      if @user_role.save
        format.html { redirect_to @user_role, notice: "Role was successfully created." }
        format.json { render :show, status: :created, location: @user_role }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user/roles/1 or /user/roles/1.json
  def update
    respond_to do |format|
      if @user_role.update(user_role_params)
        format.html { redirect_to @user_role, notice: "Role was successfully updated." }
        format.json { render :show, status: :ok, location: @user_role }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user/roles/1 or /user/roles/1.json
  def destroy
    @user_role.destroy
    respond_to do |format|
      format.html { redirect_to user_roles_url, notice: "Role was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_role
      @user_role = User::Role.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_role_params
      params.fetch(:user_role, {})
    end
end
