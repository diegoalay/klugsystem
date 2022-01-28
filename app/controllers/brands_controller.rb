class BrandsController < ApplicationSystemController
  before_action :set_brand, only: %i[update destroy]

  # GET /brands or /brands.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.brands)
      end
    end
  end

  # GET /brands/1 or /brands/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_brand

        respond_with_successful(@brand)
      end
    end
  end

  # GET /brands/new
  def new
  end

  # GET /brands/1/edit
  def edit
  end

  # POST /brands or /brands.json
  def create
    @brand = @account.brands.new(brand_params)
    @brand.user_creator = current_user
    @brand.user_modifier = current_user

    if @brand.save
      respond_with_successful(@brand)
    else
      respond_brand_with_error
    end
  end

  # PATCH/PUT /brands/1 or /brands/1.json
  def update
    @brand.user_modifier = current_user

    if @brand.update(brand_params)
      respond_with_successful(@brand)
    else
      respond_brand_with_error
    end
  end

  # DELETE /brands/1 or /brands/1.json
  def destroy
    @brand.user_modifier = current_user

    if @brand.destroy
      respond_with_successful(@brand)
    else
      respond_brand_with_error
    end
  end

  private

  def respond_brand_with_error
    return respond_with_error(@brand.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_brand
    @brand = @account.brands.find_by(id: params[:id])

    return respond_with_not_found unless @brand
  end

  # Only allow a list of trusted parameters through.
  def brand_params
    params.fetch(:brand, {}).permit(
      %i[name]
    )
  end
end