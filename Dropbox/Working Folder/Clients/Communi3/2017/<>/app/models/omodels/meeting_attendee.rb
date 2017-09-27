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

class MeetingAttendee < ActiveRecord::Base
  belongs_to :person, :counter_cache => true
  belongs_to :meeting
end
