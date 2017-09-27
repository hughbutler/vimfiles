module MeetingAttendeesHelper
  def number_to_word(num)
    case num
      when 1
        'one'
      when 2
        'two'
      when 3
        'three'
      when 4
        'four'
    end
  end

  def remaining_fees( person, event )
    event.angel_cost - person.total_fees_paid(event)
  end

  def format_history( payments )
    # payments.collect{ |payment| "<b>#{number_to_currency(payment.amount)}</b> on #{payment.created_at.strftime('%x')} #{'('+payment.note+')' if payment.note.present?}" }.join('<br/>')
  end

  def attended?( meeting_index, person_id )
    @attendee_helper ||= {}
    @attendee_helper[meeting_index] ||= @weekend.meetings[meeting_index].attendees.map(&:person_id)
    @attendee_helper[meeting_index].include? person_id
  end
end
