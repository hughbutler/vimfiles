# == Schema Information
#
# Table name: team_apps
#
#  id                   :integer          not null, primary key
#  person_id            :integer
#  event_id             :integer
#  will_attend_meetings :boolean          default(TRUE)
#  living_lifestyle     :boolean          default(FALSE)
#  is_scheduled         :boolean          default(FALSE)
#  created_at           :datetime
#  updated_at           :datetime
#

class TeamApp < ActiveRecord::Base
  belongs_to :person
  belongs_to :event
  validates_presence_of :person_id, :event_id
  
  scope :by_community, lambda { |community_id| where('people.community_id = ?', community_id).joins(:person) }
  scope :gender, lambda { |gender| where('people.gender = ?', gender).joins(:person) }
  
  def self.unscheduled(event_id)
    where(:event_id => event_id).
    where('events.gender = people.gender').
    where(:is_scheduled => false).
    joins(:event, :person).
    order('last_name, first_name')
  end
  
  def self.scheduled(event_id)
    where(:event_id => event_id).
    where('events.gender = people.gender').
    where(:is_scheduled => true).
    joins(:event, :person).
    order('last_name, first_name')
  end
  
end
