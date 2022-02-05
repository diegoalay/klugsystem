class UsersController < ApplicationSystemController
  before_action :set_user, only: %i[update destroy]

  # GET /users or /users.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.users)
      end
    end
  end

  # GET /users/1 or /users/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_user

        respond_with_successful(@user)
      end
    end
  end

  # GET /users/new
  def new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = @account.users.new(user_params)
    @user.user_creator = current_user
    @user.user_modifier = current_user

    if @user.save
      respond_with_successful(@user)
    else
      respond_user_with_error
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    @user.user_modifier = current_user

    if @user.update(user_params)
      respond_with_successful(@user)
    else
      respond_user_with_error
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.user_modifier = current_user

    if @user.destroy
      respond_with_successful(@user)
    else
      respond_user_with_error
    end
  end

  def search
    respond_with_successful(User.search(@account, @query))
  end

  private

  def respond_user_with_error
    return respond_with_error(@user.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = @account.users.find_by(id: params[:id])

    return respond_with_not_found unless @user
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.fetch(:user, {}).permit(
      %i[first_name last_name  gender birthdate title
        mobile_number telephone fax email note
        billing_name billing_address billing_identifier billing_email
      ]
    )
  end
end