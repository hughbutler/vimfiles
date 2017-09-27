module WeekendsHelper

  def next_weekend
    @next_weekend ||= current_community.weekends.upcoming.gender(current_user.gender).limit(1).take
    return @next_weekend
  end

  def weekends_for_person(person)
    current_community.weekends.gender(person.gender).order('start_date asc').limit(5)
  end

  def show_potential_coordinators
    Person.by_community(community_id).rector.select("people.id, (last_name || ', ' || first_name) as name").order('last_name, first_name')
  end

  def render_calendar_for( date )
    html = "<div class='date'>"
    html += "<div class='week'>"
    html += date.strftime("%A")
    html += "</div>"
    html += "<div class='day'>"
    html += date.strftime("%d")
    html += "</div>"
    html += "<div class='month'>"
		html += date.strftime("%B")
		html += "</div>"
		html += "</div>"

    html.html_safe
  end

  def matches_weekend_gender?( weekend )
    current_user.person.gender == weekend.gender
  end

  def current_user_is_scheduled?(weekend)
    weekend.attendees.collect{ |e| e.person }.include? current_user.person
  end

  def can_edit_weekend?( weekend, section, strict = true )
    unless weekend.is_completed?
      if section.include?( 'rector' )
        weekend.coordinator == current_user.person || ( current_user.person.role.present? && current_user.person.role.short == 'super_admin' )
      else
        has_access? section, strict
      end
    else
      false
    end
  end

end
