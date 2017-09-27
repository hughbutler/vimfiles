module PeopleHelper
  def show_spouse_of( person )
    if person.spouse.nil?
      "<strong>#{person.spouse_name}</strong>"
    else
      return link_to "#{person.spouse.first_name} #{person.spouse.last_name}", [:directory, person.spouse]
    end
  end

  def current_user? (person)
     current_user.person == person
  end

  def name_of(person, casual_format = false)
    first_name = person.try(:first_name) || 'unknown'
    last_name = person.try(:last_name) || 'unknown'

    casual_format ? "#{first_name} #{last_name}" : "#{last_name}, #{first_name}"
  end

  def contact_summary(person)
    html = person.address
    if person.main_phone
      html += '<br />'
      html += person.main_phone
    end
    html
  end

  def link_to_email(email)
    link_to email, "mailto:#{email}"
  end

  def can_view_sensitive_data? person
    #current_user?(person) || has_access?('rector', false)
    can_edit_sensitive_data? person
  end

  def can_edit_sensitive_data? person
    #current_user?(person) || has_access?(['pre_weekend_couple','rector'], false)
    current_user?(person) || has_access?(['pre_weekend_couple'], false)
  end

  def spiritual_directors
    Community.find(community_id).people.spiritual_directors.order( 'last_name asc, first_name asc' ).collect{ |e| [name_of(e), e.id] }
  end

end
