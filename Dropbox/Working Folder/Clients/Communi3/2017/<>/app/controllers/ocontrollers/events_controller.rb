class EventsController < ApplicationController
  before_filter :authenticate_user!

  # GET /events
  # GET /events.xml
  def index
    @events = Event.by_community(community_id).upcoming.order('start_date')
    @events = @events.gender(current_user.gender) unless current_user.can_see_all_events?
    @current_page = 'weekends top_upcoming_weekends'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  def archived
    @events = Event.by_community(community_id).previous.order('start_date desc')
    @current_page = 'weekends top_past_weekends'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  def closeout
    @event = Event.find(params[:event_id])
    @current_page = 'weekends top_closeout'

    @candidates = @event.event_attendees.candidate.pre_status('accepted').joins(:person).order('last_name, first_name')
    @team = @event.event_attendees.team.joins(:person).order('last_name, first_name')

    respond_to do |format|
      format.html # index.html.erb
      format.xls
      format.xml  { render :xml => @events }
    end
  end

  def ledger
    @event = Event.find(params[:event_id])
    @payments = @event.payments.team_fees.order( 'payments.created_at desc' ).includes(:person)
    @current_page = 'weekends top_ledger'
  end

  def process_candidates
    event       = Event.find(params[:event_id])
    message     = params[:message]

    event.process_candidates!( message ) # event.delay.process_candidates!( message )

    event.close!

    respond_to do |format|
      format.html { redirect_to(event_closeout_url( @event ), :notice => 'All candidates have been graduated to pescadores!') }
      format.html # index.html.erb
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    @current_page = 'top_overview'

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    @eligible = Person.by_community(community_id).members
    #@eligible = @event.gender == 'male' ? @eligible.men : @eligible.women
    @eligible = @eligible.order("last_name asc, first_name asc").collect{ |e| [e.last_name+", "+e.first_name, e.id] }

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @current_page = 'weekends top_event_details'
    @eligible = Person.by_community(community_id).members
    @eligible = @event.gender == 'male' ? @eligible.men : @eligible.women
    @eligible = @eligible.order("last_name asc, first_name asc").collect{ |e| [e.last_name+", "+e.first_name, e.id] }
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    @event.community_id = community_id

    respond_to do |format|
      if @event.save
        format.html { redirect_to(dashboard_path, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    this_url = edit_event_url(@event)
    if params[:event][:closed].present?
      this_url = event_closeout_url( @event )
    end

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(this_url, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
end
