module NominationsHelper
  def format_names( nomination, separator, proper=false )
    nomination_type = nomination.is_single_man? ? 1 : nomination.is_single_woman? ? 2 : 3
    output = nil
    if proper
      case nomination_type
        when 1
          output = "#{nomination.m_last_name}, #{nomination.m_first_name}"
          output = link_to output, Person.find_by_nomination_id(nomination.id) if nomination.is_accepted?
        when 2
          output = "#{nomination.f_last_name}, #{nomination.f_first_name}"
          output = link_to output, Person.find_by_nomination_id(nomination.id) if nomination.is_accepted?
        when 3
          output = "#{nomination.m_last_name}, #{nomination.m_first_name} #{separator} #{nomination.f_last_name}, #{nomination.f_first_name}"
          output = link_to output, Person.find_by_nomination_id(nomination.id) if nomination.is_accepted?
      end
    else
      case nomination_type
        when 1
          output = "#{nomination.m_first_name} #{nomination.m_last_name}"
          output = link_to output, Person.find_by_nomination_id(nomination.id) if nomination.is_accepted?
        when 2
          output = "#{nomination.f_first_name} #{nomination.f_last_name}"
          output = link_to output, Person.find_by_nomination_id(nomination.id) if nomination.is_accepted?
        when 3
          output = "#{nomination.m_first_name} #{nomination.m_last_name} #{separator} #{nomination.f_first_name} #{nomination.f_last_name}"
      end
    end
    output.html_safe
  end
end
