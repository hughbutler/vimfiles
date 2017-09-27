class Settings::AuthController < AuthController

    before_action :required_access!

    def required_access!
        Access.is current_user, 'super_admin'
    end

    def path_to_side_column
        'aside/settings/layout'
    end
    helper_method :path_to_side_column

end
