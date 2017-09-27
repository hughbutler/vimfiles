class QueueController < ApplicationController
  before_filter :authenticate_user!
  before_filter lambda { current_page 'candidates' }
  def index
    @candidates = EventAttendee.by_community(community_id).candidate.active.order('last_name, first_name')
    @current_page+= ' top_all_candidates'
    respond_to do |format|
      format.html # index.html.erb
      format.xls
      format.xml  { render :xml => @candidates }
    end
  end

  def invited
    @candidates = EventAttendee.by_community(community_id).candidate.active.pre_status('invited').order('last_name, first_name')
    @current_page+= ' top_invited_candidates'
    respond_to do |format|
      format.html
      format.xls
      format.xml  { render :xml => @event_attendees }
    end
  end

  def confirmed
    @events = Event.by_community(community_id).upcoming.order('start_date')

    @candidates = EventAttendee.by_community(community_id).candidate.active.pre_status('accepted').order('last_name, first_name')
    @current_page+= ' top_accepted_candidates'
    respond_to do |format|
      format.html
      format.xls
      format.xml  { render :xml => @event_attendees }
    end
  end

  def protected
    @candidates = EventAttendee.by_community(community_id).candidate.active.pre_status('protected').order('last_name, first_name')
    @current_page+= ' top_protected_candidates'
    respond_to do |format|
      format.html
      format.xls
      format.xml  { render :xml => @event_attendees }
    end
  end

  def update
    @event_attendee = EventAttendee.find(params[:id])

    respond_to do |format|
      if @event_attendee.update_attributes(params[:event_attendee])
        format.html { redirect_to(@event_attendee, :notice => 'Event attendee was successfully updated.') }
        format.js   { render :text => 'ok' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event_attendee.errors, :status => :unprocessable_entity }
        format.js   { render :text => @event_attendee.errors }
      end
    end
  end
end
