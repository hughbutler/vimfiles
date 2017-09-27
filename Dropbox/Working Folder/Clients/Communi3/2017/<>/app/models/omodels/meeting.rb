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

class Meeting < ActiveRecord::Base
  belongs_to :event
  has_many :meeting_attendees
end
