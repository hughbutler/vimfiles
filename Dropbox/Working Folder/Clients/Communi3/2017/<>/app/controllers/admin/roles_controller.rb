class Settings::RolesController < Settings::AuthController

  def index
    @roles = Role.all
    @people = Person.by_community(community_id).members.order("last_name asc, first_name asc")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles }
    end
  end

  # POST /roles
  # POST /roles.xml
  def create
    @person = Person.find(params[:person_id])

    respond_to do |format|
      if @current_community.update(community_params)
        format.html { redirect_to [:edit, @current_community], notice: 'Changes were saved.' }
      else
        format.html { render :edit }
      end

      if @person.update(role_params)#:role_id => params[:role_id])
        format.html { redirect_to(roles_path, notice: 'Saved changes.') }
      else
        format.html { redirect_to(roles_path, notice: 'Could not save.') }
      end
    end
  end


  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @person = Person.find(params[:id])
    @person.update_attributes(:role_id => -1)

    respond_to do |format|
      format.html { redirect_to(roles_url) }
      format.xml  { head :ok }
    end
  end

  private

    def roles_params
      params.require(:role).permit(:title, :street, :city,
                                        :state_id, :postal,
                                        :phone, :email, :url,
                                        :active, :event_prefix)
    end

end

