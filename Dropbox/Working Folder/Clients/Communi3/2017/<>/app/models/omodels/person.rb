# == Schema Information
#
# Table name: people
#
#  id                          :integer          not null, primary key
#  first_name                  :string(255)
#  last_name                   :string(255)
#  email                       :string(255)
#  gender                      :string(255)
#  name_on_tag                 :string(255)
#  street                      :string(255)
#  city                        :string(255)
#  state_id                    :integer
#  postal                      :string(255)
#  main_phone                  :string(255)
#  mobile_phone                :string(255)
#  is_married                  :boolean
#  spouse_name                 :string(255)
#  emergency_contact_name      :string(255)
#  emergency_contact_phone     :string(255)
#  church_name                 :string(255)
#  is_clergy                   :boolean          default(FALSE)
#  birthdate                   :date
#  who_pays                    :string(255)
#  notes                       :text
#  member_status_id            :integer          default(1)
#  wants_to_attend             :boolean          default(FALSE)
#  community_id                :integer
#  event_id                    :integer
#  role_id                     :integer
#  nomination_id               :integer
#  parent_id                   :integer
#  lft                         :integer
#  rgt                         :integer
#  event_attendees_count       :integer          default(0)
#  meeting_attendees_count     :integer          default(0)
#  outside_position_logs_count :integer          default(0)
#  created_at                  :datetime
#  updated_at                  :datetime
#  attend_last_minute          :boolean          default(FALSE)
#  has_paid                    :boolean          default(FALSE)
#  shirt_size                  :string(255)
#  sponsorship_training        :string(255)
#  birth_event_alt             :string(255)
#

require 'active_support/secure_random'
class Person < ActiveRecord::Base
  acts_as_nested_set

  has_one                           :marriage, :class_name => "Marriage", :foreign_key => "person_id_male"
  has_one                           :inverse_marriage, :class_name => "Marriage", :foreign_key => "person_id_female"
  has_one                           :husband, :through => :inverse_marriage, :source => :wife
  has_one                           :wife, :through => :marriage, :source => :husband

  has_many                          :team_apps, :dependent => :destroy
  has_many                          :users, :dependent => :destroy
  has_many                          :attribute_answers, :as => :attributable, :dependent => :destroy
  has_many                          :nominations
  has_many                          :events, :class_name => 'Event', :foreign_key => 'coordinator_id'
  has_many                          :event_attendees, :dependent => :destroy
  has_many                          :meeting_attendees, :dependent => :destroy
  has_many                          :payments
  has_many                          :outside_position_logs, :dependent => :destroy
  has_many                          :donations, :class_name => 'GeneralFund', :as => :donations, :foreign_key => 'person_id'

  belongs_to                        :state
  belongs_to                        :community
  belongs_to                        :member_status
  belongs_to                        :role
  belongs_to                        :birth_event, :class_name => 'Event', :foreign_key => 'event_id'

  accepts_nested_attributes_for     :attribute_answers, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }

  scope                             :by_community, lambda { |community_id| where('people.community_id = ?', community_id) }
  scope                             :by_status, lambda { |*status| joins(:member_status).where('member_statuses.tag = ?', (status.present?) ? status : true) }
  scope                             :members, where('member_statuses.tag IN (?)', ['member', 'admin', 'sysad']).joins(:member_status)
  scope                             :spiritual_directors, where( :spiritual_director => true )
  scope                             :category_1, lambda { includes(:event_attendees => :position).where('positions.category_1 = ?', true) }
  scope                             :category_2, lambda { |minimum| where('positions.category_2 = true').having("count(event_attendees.position_id) >= #{minimum || 1}") }
  scope                             :category_3, lambda {           includes(:event_attendees => :position).where('positions.category_3 = ?', true) }
  scope                             :category_4, lambda { |gender|  joins(:event_attendees => :event).where('events.gender = ?', gender) & Event.most_recent( 4, gender ) }
  scope                             :category_5, lambda { |gender|  having("count(event_attendees.id) >= 1") & Event.most_recent( 6, gender ) }
  scope                             :category_2_and_5, lambda { |minimum, gender| having("count(event_attendees.position_id) >= #{minimum || 0} AND count(event_attendees.id) >= 1") & Event.most_recent( 6, gender ) }
  scope                             :groupings,  lambda {           select("people.*, count(event_attendees.position_id) as position_count, count(event_attendees.id) as attendance_count").
                                                                    joins(:event_attendees => :event).
                                                                    includes(:event_attendees => :position).
                                                                    group("people.id, people.first_name, people.last_name, people.email,
                                                                           people.attend_last_minute, people.has_paid,
                                                                           people.gender, people.name_on_tag, people.street, people.city,
                                                                           people.state_id, people.postal, people.main_phone, people.mobile_phone,
                                                                           people.is_married, people.spouse_name, people.emergency_contact_name,
                                                                           people.emergency_contact_phone, people.church_name, people.is_clergy,
                                                                           people.birthdate,people.who_pays,people.notes,people.member_status_id,
                                                                           people.wants_to_attend,people.community_id,people.event_id,people.role_id,
                                                                           people.nomination_id,people.parent_id,people.lft,people.rgt,people.created_at,
                                                                           people.updated_at,people.event_attendees_count,people.meeting_attendees_count,
                                                                           people.outside_position_logs_count,event_attendees.id,event_attendees.person_id,
                                                                           people.shirt_size, people.sponsorship_training,
                                                                           event_attendees.event_id,event_attendees.attended,event_attendees.fa_needed,
                                                                           event_attendees.fa_amount_needed,event_attendees.fa_granted,event_attendees.fa_amount_granted,
                                                                           event_attendees.pre_weekend_status_id,event_attendees.last_minute,event_attendees.created_at,
                                                                           event_attendees.updated_at, event_attendees.position_id,
                                                                           event_attendees.active,
                                                                           positions.id,positions.title,positions.community_id,positions.category_1,
                                                                           positions.category_2, positions.category_3, positions.deleted, positions.created_at,
                                                                           positions.updated_at,
                                                                           events.id, events.start_date, events.end_date") }
  scope                             :attendances, lambda { |min| where('event_attendees_count >= ?', min.to_i) }
  scope                             :rector, lambda { joins(:role).where('roles.short = ?', 'rector') }
  scope                             :men, where('people.gender = ?', 'male')
  scope                             :women, where('people.gender = ?', 'female')
  scope                             :scope_gender, lambda { |gender| where( 'people.gender = ?', gender ) }

  # default_scope where("member_status_id != 5")
  #

  attr_accessor :orig_event_id

  after_initialize do
    self.orig_event_id = self.event_id
  end

  before_save do
    self.email = self.email.downcase

    if self.event_id_changed?
      attendance = Event.find(self.orig_event_id).event_attendees.find_by_person_id self.id

      if attendance
        attendance.update_attribute 'event_id', self.event_id
      end
    end
  end
  after_update :update_user_email
  after_update :update_status_if_candidate

  attr_accessor                     :schedule, :position

  validates_presence_of :first_name, :last_name, :community_id, :gender

  def self.default
    order('last_name desc, first_name desc')
  end

  def to_s
    "#{self[:first_name]} #{self[:last_name]}"
  end

  def spouse
    if self.marriage.present?
      self.marriage.wife
    elsif self.inverse_marriage.present?
      self.inverse_marriage.husband
    else
      nil
    end
  end

  def attended?(meeting)
    meeting.meeting_attendees.map{|attendee| attendee.person}.include? self
  end

  def fully_paid?(event)
    self.payments.event(event.id).team_fees.sum('amount') >= event.angel_cost
  end

  def total_fees_paid(event_id)
    self.payments.event(event_id).team_fees.sum('amount')
  end

  def remaining_fees(event_id)
    event = Event.find(event_id)
    event.angel_cost - self.payments.event(event_id).team_fees.sum('amount')
  end

  def total_donations(event_id)
    self.payments.event(event_id).donations.sum('amount')
  end

  def financial_assistance(event_id)
    attendance = self.event_attendees.by_event(event_id).first
    attendance.fa_amount_granted.to_f || 0
  end

  def total_payments(event_id)
    self.payments.event(event_id).sum('amount') + financial_assistance(event_id)
  end

  def has_outside_logs?
    self.outside_position_logs.where('person_id = ?', self.id).present?
  end

  def last_weekend_attended
    self.event_attendees.last || nil
  end

  def total_attendance_count
    self.event_attendees_count + self.outside_position_logs_count
  end

  def address
    addr = ''
    addr+= "#{self.street},<br/>" if self.street.present?
    addr+= "#{self.city}, " if self.city.present?
    addr+= self.state.short if self.state.present?
    addr+= " #{self.postal}" if self.postal.present?
    addr
  end

  def candidate?
    ['nominee', 'attendee'].include? member_status_tag
  end

  #
  #   def ispouse
  #     if self.gender == 'male'
  #       marriage = Marriage.where('person_id_male = ?', self.id).includes(:wife)
  #       'fds'
  #     else
  #       marriage = Marriage.where('person_id_female = ?', self.id)
  #       'fsd'
  #     end
  #   end

  def is(tag)
    member_status_tag == tag
  end

  def is_scheduled_for_next_weekend?
    event = Event.next_weekend_for self[:gender]
    begin
      #event.event_attendees.map(&:person_id).includes? self.id
      event.event_attendees.where("person_id = ?", self.id).first
    rescue
      nil
    end
  end

  def last_attendance
    begin
      self.event_attendees.chronological(false).last
    rescue
      ''
    end
  end

  def has_login?
    users.any?
  end

  def generate_login!
    begin
      if self.email.present?
        password = randomized_password
        # create user login or update/regenerate
        user = User.find_or_initialize_by_person_id( self.id )
        user.email                  = self.email
        user.password               = password
        user.password_confirmation  = password
        user.save
        # plaintext password
        return password #pass password back
      else
        puts 'no email present'
        return nil
      end
    rescue Exception => msg
      puts msg
      #puts e.backtrace.inspect
      return nil
    end
  end


  private

  def member_status_tag
    if self.member_status_id.present?
      status ||= MemberStatus.find(self.member_status_id)
      status.tag
    else
      false
    end
  end

  def randomized_password
    ActiveSupport::SecureRandom.hex(4)
  end

  def update_user_email
    self.users.first.update_attribute('email', self.email) if self.email_changed? && self.users.any?
  end

  def update_status_if_candidate
    self.event_attendees.first.update_attribute('last_minute', self.attend_last_minute) if self.candidate? && self.attend_last_minute_changed?
  end

end
