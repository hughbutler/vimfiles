class MeetingAttendeesController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_filter :set_page
  before_filter :authenticate_user!

  #caches_action :index

  def index
    @event_attendees = EventAttendee.by_event(params[:event_id]).team.includes(:position, nil).includes(:person => :payments).order('people.last_name ASC, people.first_name ASC').page(params[:page]).per(50)
    @event = Event.where('id = ?', params[:event_id]).includes( :meetings => :meeting_attendees ).first
    @meeting_attendee = MeetingAttendee.new
    @positions = Position.select('id, title').community(community_id).order('title').collect{ |e| [e.title, e.id] }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @meeting_attendees }
    end
  end

  def create
    @meeting_attendee = MeetingAttendee.new(:meeting_id => params[:meeting_id], :person_id => params[:person_id])
    @event = Event.find(params[:event_id])
    #expire_action(:controller => 'products', :action => 'edit')
    #expire_action :action => :index

    respond_to do |format|
      if @meeting_attendee.save
        if request.xhr?
          format.js
        end
      end
    end
  end

  def destroy
    @meeting_attendee = MeetingAttendee.find_by_meeting_id_and_person_id(params[:meeting_id], params[:person_id])
    @meeting_attendee.destroy

    respond_to :js if request.xhr?
  end

  private

  def set_page
    @current_page = 'top_meetings weekends'
    @event = Event.find(params[:event_id])
  end

end
