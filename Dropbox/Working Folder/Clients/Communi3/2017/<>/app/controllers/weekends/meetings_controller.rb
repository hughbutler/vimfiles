class Weekends::MeetingsController < Weekends::CommonController

    def index
        @weekend = Weekend.where('weekends.id = ?', params[:weekend_id]).includes( meetings: :attendees ).take
        @meetings = @weekend.meetings.all

        @attendees = @weekend.attendees.team.includes(:position, person: :payments).order('people.last_name ASC, people.first_name ASC').page(params[:page]).per(100)
        # @event_attendees = EventAttendee.by_event(params[:event_id]).team.includes(:position, nil).includes(:person => :payments).order('people.last_name ASC, people.first_name ASC').page(params[:page]).per(50)
        # @meeting_attendee = MeetingAttendee.new
        @positions = current_community.positions.order('title').collect{ |e| [e.title, e.id] }


        respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @meetings }
        end
    end

    def toggle_attendance
        person_id = params[:person_id]

        @meeting = @weekend.meetings.where('id = ?', params[:id]).take
        @attendance = @meeting.attendees.where('person_id = ?', person_id).take

        if @attendance
            @attendance.destroy
        else
            @attendance = @meeting.attendees.create(person_id: person_id)
        end
    end

    def show
        @meeting = Meeting.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @meeting }
        end
    end

    def new
        @meeting = Meeting.new

        respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @meeting }
        end
    end

    def edit
        @meeting = Meeting.find(params[:id])
    end

    def create
        @meeting = Meeting.new(params[:meeting])

        respond_to do |format|
            if @meeting.save
                format.html { redirect_to(@meeting, :notice => 'Meeting was successfully created.') }
                format.xml  { render :xml => @meeting, :status => :created, :location => @meeting }
            else
                format.html { render :action => "new" }
                format.xml  { render :xml => @meeting.errors, :status => :unprocessable_entity }
            end
        end
    end

    def update
        @meeting = Meeting.find(params[:id])

        respond_to do |format|
            if @meeting.update_attributes(params[:meeting])
                format.html { redirect_to(@meeting, :notice => 'Meeting was successfully updated.') }
                format.xml  { head :ok }
            else
                format.html { render :action => "edit" }
                format.xml  { render :xml => @meeting.errors, :status => :unprocessable_entity }
            end
        end
    end

    def destroy
        @meeting = Meeting.find(params[:id])
        @meeting.destroy

        respond_to do |format|
            format.html { redirect_to(meetings_url) }
            format.xml  { head :ok }
        end
    end
end
