# == Schema Information
#
# Table name: events
#
#  id              :integer          not null, primary key
#  weekend_number  :string(255)
#  start_date      :date
#  end_date        :date
#  location_name   :string(255)
#  street          :string(255)
#  city            :string(255)
#  state_id        :integer
#  postal          :string(255)
#  coordinator_id  :integer
#  community_id    :integer
#  theme           :text
#  attendee_cost   :integer
#  angel_cost      :integer
#  gender          :string(255)
#  verse           :text
#  created_at      :datetime
#  updated_at      :datetime
#  closed          :boolean          default(FALSE)
#  step            :string(255)      default("open")
#  verse_reference :string(255)
#

class Event < ActiveRecord::Base
  has_many                    :attribute_answers
  has_many                    :event_attendees,   :dependent => :destroy
  has_many                    :people,            :through => :event_attendees
  has_many                    :team_apps,         :dependent => :destroy
  has_many                    :meetings,          :dependent => :destroy
  has_many                    :payments,          :dependent => :destroy
  has_many                    :general_funds,     :dependent => :destroy

  belongs_to                  :community
  belongs_to                  :coordinator, :class_name => "Person", :foreign_key => "coordinator_id"
  belongs_to                  :spiritual_director, :class_name => "Person"
  belongs_to                  :state

  validates_presence_of       :title
  validates_numericality_of   :attendee_cost, :angel_cost

  scope                       :upcoming, lambda { where('events.end_date >= ?', Date.today) }
  scope                       :previous, lambda { where('events.end_date <= ?', Date.today) }
  scope                       :by_community, lambda { |community_id| where('community_id = ?', community_id) }
  scope                       :gender, lambda { |gender| where('events.gender = ?', gender) }
  scope                       :most_recent, lambda { |num, gender| where('events.start_date <= ? AND events.gender = ? AND closed = true', Date.today, gender).order('events.start_date desc').limit(num) }

  default_scope               order('weekend_number desc')

  after_create do

    4.times do |key|
      self.meetings.create(:title => key+1)
    end

  end

  def self.next_weekend_for( gender )
    return Event.where('events.end_date >= ? AND events.gender = ?', Date.today, gender).order('start_date asc').limit(1)[0]
  end

  def candidates( attended = true )
    if attended
      event_attendees.candidate.attended
    else
      event_attendees.candidate
    end
  end

  def is_completed?
    self.end_date <= Date.today
  end

  def editable?
    self.end_date > Date.today && !self.closed?
  end

  def is_started?
    self.start_date <= Date.today
  end

  def closed?
    self.closed
  end

  def open?
    is_started? && ( self.step == 'open' || self.step.nil? )
  end

  def processing_candidates?
    is_started? && self.step == 'processing_candidates'
  end

  def title
    if community.present?
      "#{community.event_prefix} ##{weekend_number}"
    else
      weekend_number
    end
  end

  def address
    addr = ''
    addr+= "#{self.street},<br/>" if self.street.present?
    addr+= "#{self.city}, " if self.city.present?
    addr+= self.state.short if self.state.present?
    addr+= " #{self.postal}" if self.postal.present?
    addr
  end

  def close!
    self.closed = true
    self.step   = 'closed'
    self.save
  end

  # def process_candidates! candidates, message
  def process_candidates! message
    candidates.each do |candidate|
      password = candidate.process! # converts candidate to full member and creates login if email present

      if password.present?
        Internal.welcome( candidate.person, password, message ).deliver
      end
    end

    # Deactivate their attendance record
    EventAttendee.where( :id => candidates.map(&:id) ).update_all( :active => false )


    # Delete the rest (Unprotected-Only)
    self.flush_unprotected_candidates!
  end

  def flush_unprotected_candidates!
    gender = self.gender
    protected_id = PreWeekendStatus.find_by_tag('protected').id
    next_event_id = Event.next_weekend_for( gender ).try(:id) || 999999999

    # Find dead candidates to delete
    # This is scoped to COMMUNITY AND NOT NEXT WEEKEND (to be safe)
    dead_ones = EventAttendee.active.candidate.unprotected.gender(gender).joins(:event)
    dead_ones = dead_ones.where("event_attendees.event_id < ? AND events.community_id = ?", next_event_id, community_id )
    dead_ones.destroy_all
  end

end
