class Settings::PositionsController < Settings::AuthController
  before_action :set_position, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @position = current_community.positions.new
  end

  def edit
  end

  def create
    @position = current_community.positions.new(position_params)

    respond_to do |format|
      if @position.save
        format.html { redirect_to(settings_positions_url, :notice => 'Saved changes') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @position.update(position_params)
        format.html { redirect_to(settings_positions_url, notice: 'Saved changes') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @position.update deleted: true

    respond_to do |format|
      format.html { redirect_to(settings_positions_url, notice: 'Deleted') }
    end
  end

  private

    def set_position
      @position = current_community.positions.find(params[:id])
    end

    def position_params
      params.require(:position).permit(:title,
                                       :category_1,
                                       :category_2,
                                       :category_3,
                                       :category_4)
    end

end
