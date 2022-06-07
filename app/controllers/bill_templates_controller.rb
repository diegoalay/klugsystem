class BillTemplatesController < ApplicationSystemController
  before_action :set_bill_template, only: %i[update destroy]

  # GET /bill_templates or /bill_templates.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        bill_templates = @account.bill_templates.map do |bill_template|
          bill_template.attributes.merge({
            product_type: I18n.t("models.products.column_enum_product_type_#{bill_template.product_type}")
          })
        end

        respond_with_successful(bill_templates)
      end
    end
  end

  # GET /bill_templates/1 or /bill_templates/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_bill_template

        respond_with_successful(@bill_template)
      end
    end
  end

  # GET /bill_templates/new
  def new
  end

  # GET /bill_templates/1/edit
  def edit
  end

  # POST /bill_templates or /bill_templates.json
  def create
    @bill_template = @account.bill_templates.new(bill_template_params)
    @bill_template.user_creator = current_user
    @bill_template.user_modifier = current_user

    if @bill_template.save
      respond_with_successful(@bill_template)
    else
      respond_bill_template_with_error
    end
  end

  # PATCH/PUT /bill_templates/1 or /bill_templates/1.json
  def update
    @bill_template.user_modifier = current_user

    if @bill_template.update(bill_template_params)
      respond_with_successful(@bill_template)
    else
      respond_bill_template_with_error
    end
  end

  # DELETE /bill_templates/1 or /bill_templates/1.json
  def destroy
    @bill_template.user_modifier = current_user

    if @bill_template.destroy
      respond_with_successful(@bill_template)
    else
      respond_bill_template_with_error
    end
  end

  def options
    respond_with_successful(BillTemplate.options(current_user))
  end

  private

  def respond_bill_template_with_error
    return respond_with_error(@bill_template.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_bill_template
    @bill_template = @account.bill_templates.find_by(id: params[:id])

    return respond_with_not_found unless @bill_template
  end

  # Only allow a list of trusted parameters through.
  def bill_template_params
    params.fetch(:bill_template, {}).permit(
      %i[name measurement_unit product_type title]
    )
  end
end