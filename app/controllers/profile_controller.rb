class ProfileController < ApplicationSystemController
    def show
      respond_to do |format|
        format.html {}
        format.json do
          respond_with_successful(@current_user)
        end
      end
    end

    # PATCH/PUT /users/1 or /users/1.json
    def update
      @current_user.user_modifier = @current_user

      if @current_user.update(user_params)
        respond_with_successful(@current_user.profile)
      else
        respond_user_with_error
      end
    end

    def respond_user_with_error
        return respond_with_error(@current_user.errors.full_messages.to_sentence)
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {}).permit(
        %i[first_name second_name first_surname second_surname telephone address]
      )
    end
end
