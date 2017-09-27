class Weekends::CommonController < AuthController

    before_action :required_access!
    before_action :set_weekend, :set_upcoming

    def required_access!
        # Access.is current_user, 'super_admin'
        # Access.is current_user, 'super_admin'
    end

    # def path_to_side_column
    # end
    # helper_method :path_to_side_column

    private

    def set_weekend
        @weekend = current_community.weekends.find(params[:weekend_id] || params[:id])
    end

    def set_upcoming
        @upcoming = current_community.weekends.upcoming.order('start_date')
        @upcoming = @upcoming.gender(current_user.gender) unless current_user.can_see_all_weekends?
    end

end
