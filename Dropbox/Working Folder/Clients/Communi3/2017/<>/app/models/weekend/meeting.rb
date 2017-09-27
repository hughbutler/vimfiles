# == Schema Information
#
# Table name: meetings
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  title      :integer
#  created_at :datetime
#  updated_at :datetime
#

class Weekend::Meeting < ApplicationRecord
    belongs_to :event
    has_many :attendees, class_name: 'Weekend::Meeting::Attendee', dependent: :destroy

    def has_attendee? person_id
        attendees.where(person_id: person_id).take
    end
end
