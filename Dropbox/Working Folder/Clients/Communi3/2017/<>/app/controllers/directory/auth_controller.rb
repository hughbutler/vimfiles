class Directory::AuthController < AuthController

  before_action :required_access!

  def required_access!
    # Access.is current_user, 'super_admin'
  end

end

