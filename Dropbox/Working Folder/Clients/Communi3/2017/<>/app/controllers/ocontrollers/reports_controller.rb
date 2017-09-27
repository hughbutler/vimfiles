class ReportsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def rector

    # Searching
    @gender = params[:gender].present? ? params[:gender] : 'male'
    f = current_community
    f = f.events.previous.gender( @gender ).includes(:event_attendees => :person).collect{ |e| e.event_attendees }.flatten.uniq


    if params[:category_1] || \
       params[:category_2] || \
       params[:category_3] || \
       params[:category_4] || \
       params[:category_5] || \
       params[:category_6]
    # begin

      ###########
      # => Event Attendees
      f = f.select { |a| a.person.event_attendees.joins(:event).where('events.end_date <= ?', Date.today).count > (params[:category_6] ? 5 : 0) }.flatten

      ###########
      # => Person
      f = f.map( &:person_id ).uniq
      # Dirty Bulk Find to Re-Filter
      # p = Person.where( 'people.id in (?)', f ).joins(:event_attendees => [:event => :community]).joins(:event_attendees => :position).joins(:outside_position_logs => :position).joins(:state)
      p = Person.where( 'people.id in (?)', f ).includes(:event_attendees => [:event => :community]).includes(:event_attendees => :position).includes(:outside_position_logs => :position).includes(:state)

      ###########
      # Conditional
      cat1 = current_community.positions.category_1.map(&:id) if params[:category_1]
      cat2 = current_community.positions.category_2.map(&:id) if params[:category_2]
      cat3 = current_community.positions.category_3.map(&:id) if params[:category_3]
      cat4 = current_community.positions.category_4.map(&:id) if params[:category_4]
      cat5 = params[:category_5]
      most_recent_people = Event.most_recent(4,@gender).collect{ |e| e.event_attendees }.flatten.collect{ |ea| ea.person }.flatten.uniq


      # Filtering People by Positions
      p = p.select do |a|
        should_select = true

        history = a.event_attendees.map(&:position_id)
        history << a.outside_position_logs.map(&:position_id)
        history.flatten!
        history.uniq!

        if cat1.present?
          should_select = false unless (cat1 & history).present?
        end
        if cat2.present?
          matches = cat2 & history
          should_select = false unless matches.count >= params[:category_2_minimum].to_i
        end
        if cat3.present?
          should_select = false unless (cat3 & history).present?
        end
        if cat4.present?
          should_select = false unless (cat4 & history).present?
        end
        if cat5.present?
          should_select = false unless most_recent_people.include?(a)
        end

        should_select
      end
      # p = p.select { |a| \
      #                     ( cat1.present? ? (cat1 & a.event_attendees.map(&:position_id)).present? : true ) \
      #                       && \
      #                     ( cat2.present? ? (cat2 & a.event_attendees.map(&:position_id)).count >= params[:category_2_minimum].to_i : true ) \
      #                       && \
      #                     ( cat3.present? ? (cat3 & a.event_attendees.map(&:position_id)).present? : true ) \
      #                       && \
      #                     ( cat4.present? ? (cat4 & a.event_attendees.map(&:position_id)).present? : true ) \
      #                       && \
      #                     ( cat5.present? ? most_recent_people.include?(a) : true )
      # }.flatten
      @people = p.flatten.uniq.compact.sort

    else
      @people = nil
    end


    # rescue
    #   @people = []
    # end

    @current_page = 'reports top_rector_report'
    respond_to do |format|
      format.html # index.html.erb
      format.xls
    end

  end

  def backup_experience

    @gender   = params[:g] || 'male'
    @position = params[:p] ? params[:p] : '0'
    @weekend  = params[:w] ? params[:w] : '0'

    @genders        = ['male','female']
    @positions      = current_community.positions.order('title asc')

    #begin
      matched_positions = @position.include?('0') ? current_community.positions : current_community.positions.find( params[:p] )
      matched_events    = @weekend.include?('0') ? current_community.events : current_community.events.find( params[:w] )

      people = current_community.people.gender(@gender).includes(:event_attendees)
      @people = people.select { |p| \
                                     (matched_events.map(&:id) & p.event_attendees.map(&:event_id)).present? \
                                       &&
                                     (matched_positions.map(&:id) & p.event_attendees.map(&:position_id)).present?
      }
    #rescue
      #@people = []
    #end

    @current_page = 'reports top_experience_report'
    respond_to do |format|
      format.html # index.html.erb
      format.xls
    end

  end

  def experience

    @genders        = ['male','female']
    @positions      = current_community.positions.order('title asc')

    if params[:p] && params[:w] && params[:g]
      @gender   = params[:g] || 'male'
      @position = params[:p].include?('-1') ? current_community.positions.select('id').collect{ |e| e.id } : params[:p]
      @weekend  = params[:w].include?('0') ? current_community.events.select('id').collect { |e| e.id } : params[:w]

      results = current_community

      # Weekends
      results = results.event_attendees.where('event_attendees.event_id in (?)', @weekend)

      # Positions + Gender
      if @position.include? '0'
        results = results.joins(:person).where('people.gender = ?', @gender)
      else
        results = results.joins(:person).where("(event_attendees.position_id IN (?) or event_attendees.aux_position_id IN (?)) AND people.gender = ?", @position, @position, @gender)
      end

      @people = results.collect { |e| e.person }.uniq

      # Outside Positions + Gender
      if @weekend.include? '-1'
        outside_results = current_community.outside_position_logs.joins(:person).where('outside_position_logs.position_id IN (?) AND people.gender = ?', @position, @gender)
        @people << outside_results.collect{ |e| e.person }.uniq
        @people.flatten!.uniq!
      end

    else
      @people = []
    end

    @current_page = 'reports top_experience_report'
    respond_to do |format|
      format.html # index.html.erb
      format.xls
    end

  end

end
