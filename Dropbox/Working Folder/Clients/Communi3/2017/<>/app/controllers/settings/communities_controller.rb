class Settings::CommunitiesController < Settings::AuthController

  def show
  end

  def edit
  end

  def update
    respond_to do |format|

      if @current_community.update(community_params)
        format.html { redirect_to settings_community_url, notice: 'Saved changes' }
      else
        format.html { render :edit }
      end
    end
  end

  private

    def community_params
      params.require(:community).permit(:title, :street, :city,
                                        :state_id, :postal,
                                        :phone, :email, :url,
                                        :active, :event_prefix)
    end

end
