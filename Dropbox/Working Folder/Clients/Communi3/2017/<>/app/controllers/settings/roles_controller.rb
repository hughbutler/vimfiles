class Settings::RolesController < Settings::AuthController
  before_action :set_role, only: [:show, :update, :destroy]

  def index
    @roles = Role.all
    @people = current_community.people.members.order("last_name asc, first_name asc")
  end

  def create

    respond_to do |format|
      if @person.update(role_id: params[:role_id])
        format.html { redirect_to(settings_roles_path, notice: 'Changes saved') }
      else
        format.html { redirect_to(settings_roles_path, :notice => 'Couldn\'t add user to role.') }
      end
    end
  end

  def destroy
    @person.update(role_id: -1)

    respond_to do |format|
      format.html { redirect_to(settings_roles_url) }
    end
  end

  private

    def set_person
      @person = current_community.people.find(params[:person_id])
    end

end

