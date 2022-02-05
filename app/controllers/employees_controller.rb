class EmployeesController < ApplicationSystemController
  before_action :set_employee, only: %i[update destroy]

  # GET /employees or /employees.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.employees)
      end
    end
  end

  # GET /employees/1 or /employees/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_employee

        respond_with_successful(@employee)
      end
    end
  end

  # GET /employees/new
  def new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees or /employees.json
  def create
    @employee = @account.employees.new(employee_params)
    @employee.user_creator = current_user
    @employee.user_modifier = current_user

    if @employee.save
      respond_with_successful(@employee)
    else
      respond_employee_with_error
    end
  end

  # PATCH/PUT /employees/1 or /employees/1.json
  def update
    @employee.user_modifier = current_user

    if @employee.update(employee_params)
      respond_with_successful(@employee)
    else
      respond_employee_with_error
    end
  end

  # DELETE /employees/1 or /employees/1.json
  def destroy
    @employee.user_modifier = current_user

    if @employee.destroy
      respond_with_successful(@employee)
    else
      respond_employee_with_error
    end
  end

  def search
    respond_with_successful(Employeee.search(@account, @query))
  end

  def options
    respond_with_successful(Employeee.options(@account))
  end

  private

  def respond_employee_with_error
    return respond_with_error(@employee.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = @account.employees.find_by(id: params[:id])

    return respond_with_not_found unless @employee
  end

  # Only allow a list of trusted parameters through.
  def employee_params
    params.fetch(:employee, {}).permit(
      %i[
        first_name
        second_name
        third_name
        first_surname
        second_surname
        married_name
        birthdate
        identity_document_number
        passport_number
        marital_status
        gender
        blood_type
        biography
        family_background
        health_details
        contract_date
        salary_base
        salary_administrative
        bonuses
        users_id
      ]
    )
  end
end