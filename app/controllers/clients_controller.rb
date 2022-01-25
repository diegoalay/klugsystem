class ClientsController < ApplicationController
  before_action :set_client, only: %i[update destroy ]

  # GET /clients or /clients.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.clients)
      end
  end

  # GET /clients/1 or /clients/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_client

        respond_with_successful(@client)
      end
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients or /clients.json
  def create
    @client = @account.clients.new(client_params)
    @client = @client.user_creator = current_user

    if @client.save
      @client.log_create
    else
      respond_client_with_error
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    @client.user_modifier = current_user

    if @client.update(client_params)
      @client.log_update

      respond_with_successful(@client)
    else
      respond_client_with_error
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    @client.user_modifier = current_user

    if @client.destroy
      @client.log_destroy

      respond_with_successful(@client)
    else
      respond_client_with_error
    end
  end

  private
    def respond_client_with_error
      respond_with_error(@client.errors.full_messages.to_sentence)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = @account.clients.find_by(id: params[:id])

      return respond_with_not_found unless @client
    end

    # Only allow a list of trusted parameters through.
    def client_params
      params.fetch(:client, {}).permit(
        %i[first_name last_name telephone email gender birthdate
          billing_name billing_address billing_identifier note
        ]
      )
    end
end
