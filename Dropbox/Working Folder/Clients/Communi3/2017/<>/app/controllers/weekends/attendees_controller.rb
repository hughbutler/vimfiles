class Weekends::AttendeesController < Weekends::CommonController

    def index
        @team = @weekend.attendees.team.joins(:person).order('people.last_name ASC, people.first_name ASC')
    end

    def roster
        @event = Event.find(params[:event_id])
        @team = @event.event_attendees.team.joins(:person).order('last_name, first_name')

        respond_to do |format|
            format.xls
        end
    end

    def show
        @event_attendee = EventAttendee.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @event_attendee }
        end
    end

    # GET /event_attendees/new
    # GET /event_attendees/new.xml
    def new
        @event_attendee = EventAttendee.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @event_attendee }
        end
    end

    def edit
        @attendee = @weekend.attendees.find(params[:id])
    end

    # POST /event_attendees
    # POST /event_attendees.xml
    def create
        @event_attendee = EventAttendee.new(params[:event_attendee])
        expire_caches

        respond_to do |format|
            if @event_attendee.save
                format.html { redirect_to(@event_attendee, :notice => 'Event attendee was successfully created.') }
                format.xml  { render :xml => @event_attendee, :status => :created, :location => @event_attendee }
                format.js
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @event_attendee.errors, :status => :unprocessable_entity }
            end
        end
    end

    # PUT /event_attendees/1
    # PUT /event_attendees/1.xml
    def update
        @attendee = @weekend.attendees.find(params[:id])
        # expire_caches

        @attendee.update(allowed_params)
        # respond_to do |format|
        #         format.html { redirect_to(@event_attendee, :notice => 'Event attendee was successfully updated.') }
        #         format.js   { render :text => 'ok' }
        #     else
        #         format.html { render :action => "edit" }
        #         format.js   { render :text => @event_attendee.errors }
        #     end
        # end
    end

    def update_bulk_attenders
        #@attendee_ids = params[:event_attendee_ids]
        params[:event_attendees].each do |key, value|
            #@person = Person.find(attendee_id)
            if params[:event_attendees][key][:schedule] == '1'
                @attendee = EventAttendee.create(:person_id => key, :event_id => params[:event_id], :position_id => params[:event_attendees][key][:position], :attended => false )
                @team_app = TeamApp.find_by_person_id_and_event_id(key, params[:event_id])
                @team_app.update_attributes(:is_scheduled => true)
                if @attendee.person.member_status.tag != 'member'
                    @attendee.person.member_status_id = 2
                    @attendee.person.save
                end
            end
        end
        flash[:notice] = "Schedule has been saved!"
        redirect_to event_event_attendees_url(params[:event_id])

    end

    # DELETE /event_attendees/1
    # DELETE /event_attendees/1.xml
    def destroy
        @event_attendee = EventAttendee.find(params[:id])
        if @event_attendee.position_id.nil?
            @event_attendee.person.member_status_id = 1
            @event_attendee.person.save
        end
        @team_app = TeamApp.find_by_person_id_and_event_id(@event_attendee.person_id, @event_attendee.event_id)
        #@team_app.update_attributes(:is_scheduled => false)
        @team_app.try(:destroy)
        @event_attendee.destroy
        expire_caches

        respond_to do |format|
            format.html { redirect_to(event_event_attendees_url(params[:event_id])) }
            format.xml  { head :ok }
            format.js
        end
    end

    private

    def allowed_params
        params.require(:weekend_attendee).permit( :position_id, :aux_position_id,
            :fa_needed, :fa_granted, :fa_amount_needed, :fa_amount_granted
        )
    end

    def expire_caches
        #expire_action :controller => :meeting_attendees, :action => :index
    end

end
