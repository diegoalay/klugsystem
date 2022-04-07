
class ExpedituresController < ApplicationSystemController
    before_action :set_expediture, only: %i[update destroy]

    # GET /expeditures or /expeditures.json
    def index
      respond_to do |format|
        format.html {}
        format.json do

          respond_with_successful(Finance::ExpeditureQuery.new(@account).index(@query))
        end
      end
    end

    # GET /expeditures/1 or /expeditures/1.json
    def show
      respond_to do |format|
        format.html {}
        format.json do
          set_expediture

          return respond_with_not_found unless @expediture

          respond_with_successful(@expediture)
        end
      end
    end

    # GET /expeditures/new
    def new
    end

    # GET /expeditures/1/edit
    def edit
    end

    # POST /expeditures or /expeditures.json
    def create
      @expediture = @account.expeditures.new(expediture_params)
      @expediture.user_creator = current_user
      @expediture.user_modifier = current_user
      @expediture.cash_register = current_user.cash_register

      if @expediture.save
        respond_with_successful(@expediture)
      else
        respond_expediture_with_error
      end
    end

    # PATCH/PUT /expeditures/1 or /expeditures/1.json
    def update
      return respond_with_not_found unless @expediture

      @expediture.user_modifier = current_user

      if @expediture.update(expediture_params)
        respond_with_successful(@expediture)
      else
        respond_expediture_with_error
      end
    end

    # DELETE /expeditures/1 or /expeditures/1.json
    def destroy
      return respond_with_not_found unless @expediture

      @expediture.user_modifier = current_user

      if @expediture.destroy
        respond_with_successful(@expediture)
      else
        respond_expediture_with_error
      end
    end

    def index_options
      respond_with_successful(Finance::ExpeditureQuery.new(@account).index_options)
    end

    def options
      respond_with_successful(Finance::ExpeditureQuery.new(@account).options)
    end

    private

    def respond_expediture_with_error
      return respond_with_error(@expediture.errors.full_messages.to_sentence)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_expediture
      @expediture = @account.expeditures.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def expediture_params
      params.fetch(:expediture, {}).permit(
        %i[description note amount expediture_date catalog_expediture_type_id]
      )
    end
  end