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

class Weekend::TeamApp < ApplicationRecord
    belongs_to :person
    belongs_to :weekend
    validates_presence_of :person_id, :weekend_id

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
