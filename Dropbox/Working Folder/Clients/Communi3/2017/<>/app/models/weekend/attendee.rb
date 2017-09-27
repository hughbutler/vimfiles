# == Schema Information
#
# Table name: event_attendees
#
#  id                    :integer          not null, primary key
#  person_id             :integer
#  position_id           :integer
#  event_id              :integer
#  attended              :boolean          default(TRUE)
#  fa_needed             :boolean          default(FALSE)
#  fa_amount_needed      :string(255)
#  fa_granted            :boolean          default(FALSE)
#  fa_amount_granted     :string(255)
#  pre_weekend_status_id :integer          default(1)
#  last_minute           :boolean          default(FALSE)
#  created_at            :datetime
#  updated_at            :datetime
#  active                :boolean          default(TRUE)
#  aux_position_id       :integer
#

class Weekend::Attendee < ApplicationRecord

  belongs_to            :person, :counter_cache => true
  belongs_to            :pre_weekend_status
  belongs_to            :weekend
  belongs_to            :position
  belongs_to            :aux_position, :class_name => 'Position'

  # scope                 :by_community, lambda { |community_id| where('people.community_id = ?', community_id).joins(:person) }
  scope                 :by_weekend, -> (wid) { where('weekend_attendees.weekend_id = ?', wid) }
  scope                 :pre_status, -> (status) { where('pre_weekend_statuses.tag = ?', status).joins(:pre_weekend_status) }
  scope                 :candidate, -> { where('position_id = 0') }
  scope                 :team, -> { where('position_id IS NULL or position_id <> 0') }
  scope                 :attended, -> { where('attended = ?', true) }
  scope                 :men, -> { joins(:person).where('people.gender = ?', 'male') }
  scope                 :women, -> { joins(:person).where('people.gender = ?', 'female') }
  scope                 :gender, -> (gender) { joins(:person).where('people.gender = ?', gender) }
  scope                 :safe, -> { joins(:pre_weekend_status).where('pre_weekend_statuses.tag = ?', 'protected') }
  scope                 :not_safe, -> { joins(:pre_weekend_status).where('pre_weekend_statuses.tag != ?', 'protected') }
  scope                 :active, -> { where('active = ?', true) }

  # scope :candidate, where('position_id IS NULL or position_id = 0')
  # scope :team, where('position_id IS NOT NULL and position_id <> 0')
  #
  scope                 :chronological, -> (desc = true) { joins(:weekend).order("weekends.weekend_number #{desc ? 'desc' : 'asc'}") }

  validates_presence_of :weekend_id

  def to_s
    self.weekend.title
  end

  def positions
    position_array = []
    position_array << (position.try(:title))
    position_array << aux_position.title if aux_position.try(:title).present?

    position_array.join(', ')
  end

  def remaining_fees
    fa_granted = self.fa_granted? ? (self.fa_amount_granted || 0) : 0
    self.weekend.angel_cost - self.person.payments.weekend(weekend_id).team_fees.sum('amount') - fa_granted.to_f
  end

  def candidate?
    self.position_id == 0
  end

  def team?
    self.position_id != 0
  end

  def process!
    # update person's status to member
    self.person.update_attributes( :member_status_id => MemberStatus.find_by_tag('member').id,
                                   :weekend_id => self.weekend_id )

    # create a user login
    return self.person.generate_login! #returns the password (used in the email)
  end

end
