class Weekends::TeamAppsController < Weekends::CommonController
    before_filter :authenticate_user!

    def new
        @team_app = @weekend.team_apps.new

        # @events = Event.by_community(community_id).upcoming.gender(current_user.person.gender).order('start_date asc').limit(5)
    end
    def create
        @app = nil
        if TeamApp.find_by_person_id_and_event_id(params[:team_app][:person_id], params[:team_app][:event_id]).nil?
            @app = TeamApp.new(params[:team_app])
            @attendee = EventAttendee.create( :event_id => @app.event_id, :person_id => @app.person_id, :position_id => -1 )
            @app.save

            # Email Rectors of New Signups
            current_community.rectors(@attendee.event.gender).each do |rector|
                SystemMailer.team_app_notifier( rector, @attendee.person, @attendee.event).deliver
            end
        end
        respond_to do |format|
            format.js { render :json => @app }
            format.html { redirect_to(dashboard_path, :notice => 'Your team application has been submitted.') }
        end
    end

end
