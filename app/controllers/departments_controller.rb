class DepartmentsController < ApplicationSystemController
  before_action :set_department, only: %i[update destroy]

  # GET /departments or /departments.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.departments)
      end
    end
  end

  # GET /departments/1 or /departments/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_department

        respond_with_successful(@department)
      end
    end
  end

  # GET /departments/new
  def new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments or /departments.json
  def create
    @department = @account.departments.new(department_params)
    @department.user_creator = current_user
    @department.user_modifier = current_user

    if @department.save
      respond_with_successful(@department)
    else
      respond_department_with_error
    end
  end

  # PATCH/PUT /departments/1 or /departments/1.json
  def update
    @department.user_modifier = current_user

    if @department.update(department_params)
      respond_with_successful(@department)
    else
      respond_department_with_error
    end
  end

  def options
    respond_with_successful(Department.options(@account))
  end

  # DELETE /departments/1 or /departments/1.json
  def destroy
    @department.user_modifier = current_user

    if @department.destroy
      respond_with_successful(@department)
    else
      respond_department_with_error
    end
  end

  private

  def respond_department_with_error
    return respond_with_error(@department.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_department
    @department = @account.departments.find_by(id: params[:id])

    return respond_with_not_found unless @department
  end

  # Only allow a list of trusted parameters through.
  def department_params
    params.fetch(:department, {}).permit(
      %i[name departments_id]
    )
  end
end