module EventAttendeesHelper
  def show_if_none(dataset)
    "<tr class='empty_row'><td colspan='2'>No one has been selected yet...</td></tr>".html_safe if dataset.empty? or dataset.nil?
  end

  def events_by_gender(g)
    Event.by_community(community_id).gender(g).order('start_date asc').limit(5)
  end
end
