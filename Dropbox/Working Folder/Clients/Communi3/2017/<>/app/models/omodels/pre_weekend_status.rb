# == Schema Information
#
# Table name: pre_weekend_statuses
#
#  id    :integer          not null, primary key
#  title :string(255)
#  tag   :string(255)
#

class PreWeekendStatus < ActiveRecord::Base
  has_many :event_attendees
end
