class Settings::AttributesController < Settings::AuthController
  before_action :set_attribute, only: [:show, :edit, :update, :destroy]

  def index
    @attributes = current_community.custom_fields
  end

  def show
  end

  def new
    @attribute = current_community.custom_fields.new
  end

  def edit
  end

  def create
    @attribute = current_community.custom_fields.new(attribute_params)

    respond_to do |format|
      if @attribute.save
        format.html { redirect_to(settings_attributes_url, notice: 'Saved changes.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @attribute.update(attribute_params)
        format.html { redirect_to(settings_attributes_url, notice: 'Saved changes') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @attribute.destroy

    respond_to do |format|
      format.html { redirect_to(settings_attributes_url) }
    end
  end

  private

    def set_attribute
      @attribute = current_community.custom_fields.find(params[:id])
    end

    def attribute_params
      params.require(:attribute).permit(:title,
                                        :hint_field,
                                        :is_searchable,
                                        :attribute_type_id,
                                        :attribute_position_id)
    end

end
