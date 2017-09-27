module DashboardHelper
  def nomination_count
    Nomination.by_community(session[:community_id]).where(:is_accepted => false).order('is_accepted, created_at desc').count
  end
end
