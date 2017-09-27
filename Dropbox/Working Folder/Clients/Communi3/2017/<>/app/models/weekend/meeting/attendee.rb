# == Schema Information
#
# Table name: meeting_attendees
#
#  id         :integer          not null, primary key
#  meeting_id :integer
#  person_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Weekend::Meeting::Attendee < ApplicationRecord
    belongs_to :person
    belongs_to :meeting
end
