class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :set_community_id
  before_filter :role_summary_data

  def after_sign_in_path_for(resource_or_scope)
    dashboard_path
  end

  def current_page( page )
    @current_page = page
  end

  def community_id
    session[:community_id] || get_community_id
  end

  def current_community
    @current_community ||= current_user.community
    # Community.find community_id
  end
  helper_method :current_community

  private

  def set_community_id
    session[:community_id] = get_community_id
  end

  def get_community_id
    if current_user.present?
      p = Person.find(current_user.person_id)
      p.community_id
    else
      nil
    end
  end

  def role_summary_data
    @events = Event.by_community(community_id).where('DATE(start_date) >= DATE(?)', Time.now).order('start_date asc').limit(5)
    @global_past_events= Event.by_community(community_id).where('DATE(start_date) <= DATE(?) AND closed = ?', Time.now, false).order('start_date desc').limit(10)
    @global_candidates = EventAttendee.by_community(community_id).candidate.active.order('last_name, first_name')
  end
end
