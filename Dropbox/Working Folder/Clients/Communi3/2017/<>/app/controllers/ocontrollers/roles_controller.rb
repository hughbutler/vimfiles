class RolesController < ApplicationController
  before_filter :authenticate_user!
  before_filter lambda { current_page 'settings top_role' }
  
  # GET /roles
  # GET /roles.xml
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
      if @person.update_attributes(:role_id => params[:role_id])
        format.html { redirect_to(roles_path, :notice => 'Added user to role.') }
      else
        format.html { redirect_to(roles_path, :notice => 'Couldn\'t add user to role.') }
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
    
end
