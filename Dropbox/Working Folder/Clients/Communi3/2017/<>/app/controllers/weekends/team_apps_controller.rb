class Weekends::TeamAppsController < Weekends::CommonController
    before_filter :authenticate_user!
    respond_to :html

    def new
        @team_app = @weekend.team_apps.new

        # @events = Event.by_community(community_id).upcoming.gender(current_user.person.gender).order('start_date asc').limit(5)
    end
    def create
        @team_app = @weekend.team_apps.new(allowed_params)
        @attendee = @weekend.attendees.new(person_id: allowed_params[:person_id], position_id: -1)
        if @team_app.valid? && @attendee.valid?
            ActiveRecord::Base.transaction do
                @team_app.save
                @attendee.save
            end
        end

        if @team_app.persisted? && @attendee.persisted?
            # Email Rectors of New Signups
            current_community.rectors(@attendee.weekend.gender).each do |rector|
                # SystemMailer.team_app_notifier( rector, @attendee.person, @weekend).deliver
            end

            redirect_to(weekend_meetings_url(@weekend), :notice => 'Added to the weekend.')
        else
            redirect_to(weekend_meetings_url(@weekend), :alert => 'System Failure: Could not add to weekend.')
        end
    end

    private

    def allowed_params
        params.require(:weekend_team_app).permit( %w(person_id will_attend_meetings living_lifestyle) )
    end
end
