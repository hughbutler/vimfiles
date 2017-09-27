module ApplicationHelper


  def showing_event?
    (params[:controller] == 'events' and params[:id].present?) || params[:event_id].present?
  end

  def community_id
    session[:community_id]
  end

  def community_count
    Person.by_community(community_id).length
  end

  def upcoming_events_for( user )
    if has_access? 'rector'
      return current_user.events.upcoming
    elsif has_access? ['core','leader']
      weekends = []
      weekends << Event.next_weekend_for(user.gender)
      return weekends
    else
      return Event.upcoming
    end
  end

  def age(birthday = nil)
    if birthday
      now = Time.now.utc.to_date
      now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
    end
  end

  def member_status_id_for(tag)
    status = MemberStatus.find_by_tag(tag)
    status.id
  end

  def has_access?(section, strict = true)
    if has_role?
      role = current_user.person.role
      if strict
        section.include?(role.short)
      else
        section.include?(role.short) || 'super_admin'.include?(role.short)
      end
    else
      false
    end
  end

  def has_role?
    current_user.person.role.present?
  end

  def role_action(role)
    case role
    when 'super_admin'
      'Super Admin Access'
    when 'rector'
      'Manage weekend...'
    when 'core'
      'Manage meetings...'
    when 'leader'
      'Leader'
    when 'pre_weekend_couple'
      'Manage candidates...'
    when 'fourth_day_couple'
      'Fourth Day Couple'
    end
  end

  def link_role_to(event)
    # route = event_meetings_path(event)
    # route = event_event_attendees_path(event) if has_access? 'super_admin'
    # route = edit_event_path(event) if has_access? 'rector'

    link_to event.title, events_path if event.title
  end

end
