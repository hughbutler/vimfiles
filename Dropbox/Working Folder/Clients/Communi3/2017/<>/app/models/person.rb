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
#  weekend_id                    :integer
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

# require 'active_support/secure_random'
class Person < ApplicationRecord
  # acts_as_nested_set

  after_initialize do
    self.orig_weekend_id = self.weekend_id
  end

  before_save do
    self.email = self.email.downcase

    if self.weekend_id_changed?
      attendance = Weekend.find(self.orig_weekend_id).attendees.find_by_person_id self.id

      if attendance
        attendance.update_attribute 'weekend_id', self.weekend_id
      end
    end
  end

  after_update :update_user_email
  after_update :update_status_if_candidate
  attr_accessor :orig_weekend_id, :schedule, :position

  has_one                           :marriage, :class_name => "Marriage", :foreign_key => "person_id_male"
  has_one                           :inverse_marriage, :class_name => "Marriage", :foreign_key => "person_id_female"
  has_one                           :husband, :through => :inverse_marriage, :source => :wife
  has_one                           :wife, :through => :marriage, :source => :husband

  has_many                          :users, :dependent => :destroy
  has_many                          :attribute_answers, as: :attributable, class_name: 'Attribute::Answer', dependent: :destroy

  has_many                          :team_apps, class_name: 'Weekend::TeamApp', dependent: :destroy
  has_many                          :nominations, class_name: 'Weekend::Nomination'
  has_many                          :weekends, foreign_key: 'coordinator_id'
  has_many                          :attendees, class_name: 'Weekend::Attendee', dependent: :destroy
  has_many                          :meeting_attendees, dependent: :destroy
  has_many                          :payments, class_name: 'Weekend::Payment'

  has_many                          :outside_position_logs, :dependent => :destroy
  has_many                          :donations, :class_name => 'GeneralFund', :as => :donations, :foreign_key => 'person_id'
  has_many                          :children, class_name: 'Person', foreign_key: 'parent_id'

  belongs_to                        :parent, class_name: 'Person'
  belongs_to                        :state
  belongs_to                        :community
  belongs_to                        :member_status
  belongs_to                        :role
  belongs_to                        :birth_weekend, class_name: 'Weekend', foreign_key: 'weekend_id'

  accepts_nested_attributes_for     :attribute_answers, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }

  # scope :complete, -> { joins([:contact, :experience, :financial, :franchise, :legal]).where("(felony IS NOT NULL) AND (truth IS NOT NULL) AND ('authorization' IS NOT NULL)") }
  # scope                             :by_community, lambda { |community_id| where('people.community_id = ?', community_id) }
  scope :by_status,             -> (*status) { joins(:member_status).where('member_statuses.tag = ?', (status.present?) ? status : true) }
  scope :members,               -> { where('member_statuses.tag IN (?)', ['member', 'admin', 'sysad']).joins(:member_status) }
  scope :spiritual_directors,   -> { where( :spiritual_director => true ) }
  scope :category_1,            -> { includes(:weekend_attendees => :position).where('positions.category_1 = ?', true) }
  scope :category_2,            -> (minimum) {  where('positions.category_2 = true').having("count(weekend_attendees.position_id) >= #{minimum || 1}") }
  scope :category_3,            -> { includes(:weekend_attendees => :position).where('positions.category_3 = ?', true) }
  scope :category_4,            -> (gender) { joins(:weekend_attendees => :weekend).where('weekends.gender = ?', gender) & Weekend.most_recent( 4, gender ) }
  scope :category_5,            -> (gender) { having("count(weekend_attendees.id) >= 1") & Weekend.most_recent( 6, gender ) }
  scope :category_2_and_5,      -> (minimum, gender) { having("count(weekend_attendees.position_id) >= #{minimum || 0} AND count(weekend_attendees.id) >= 1") & Weekend.most_recent( 6, gender ) }
  scope :groupings,             -> { select("people.*, count(weekend_attendees.position_id) as position_count, count(weekend_attendees.id) as attendance_count").
                                                                    joins(:weekend_attendees => :weekend).
                                                                    includes(:weekend_attendees => :position).
                                                                    group("people.id, people.first_name, people.last_name, people.email,
                                                                           people.attend_last_minute, people.has_paid,
                                                                           people.gender, people.name_on_tag, people.street, people.city,
                                                                           people.state_id, people.postal, people.main_phone, people.mobile_phone,
                                                                           people.is_married, people.spouse_name, people.emergency_contact_name,
                                                                           people.emergency_contact_phone, people.church_name, people.is_clergy,
                                                                           people.birthdate,people.who_pays,people.notes,people.member_status_id,
                                                                           people.wants_to_attend,people.community_id,people.weekend_id,people.role_id,
                                                                           people.nomination_id,people.parent_id,people.lft,people.rgt,people.created_at,
                                                                           people.updated_at,people.weekend_attendees_count,people.meeting_attendees_count,
                                                                           people.outside_position_logs_count,weekend_attendees.id,weekend_attendees.person_id,
                                                                           people.shirt_size, people.sponsorship_training,
                                                                           weekend_attendees.weekend_id,weekend_attendees.attended,weekend_attendees.fa_needed,
                                                                           weekend_attendees.fa_amount_needed,weekend_attendees.fa_granted,weekend_attendees.fa_amount_granted,
                                                                           weekend_attendees.pre_weekend_status_id,weekend_attendees.last_minute,weekend_attendees.created_at,
                                                                           weekend_attendees.updated_at, weekend_attendees.position_id,
                                                                           weekend_attendees.active,
                                                                           positions.id,positions.title,positions.community_id,positions.category_1,
                                                                           positions.category_2, positions.category_3, positions.deleted, positions.created_at,
                                                                           positions.updated_at,
                                                                           weekends.id, weekends.start_date, weekends.end_date") }
  scope :attendances,     -> (min) { where('weekend_attendees_count >= ?', min.to_i) }
  scope :rector,          -> { joins(:role).where('roles.short = ?', 'rector') }
  scope :men,             -> { where('people.gender = ?', 'male') }
  scope :women,           -> { where('people.gender = ?', 'female') }
  scope :gender,          -> (gender) { where( 'people.gender = ?', gender ) }

  # default_scope where("member_status_id != 5")
  #

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

  def fully_paid?(weekend)
    total_fees_paid(weekend.id) >= weekend.angel_cost
  end

  def total_fees_paid(weekend_id)
    payments.where(weekend_id: weekend_id).team_fees.sum(:amount)
  end

  def remaining_fees(weekend_id)
    weekend = Weekend.where(id: weekend_id).includes(:payments).take
    weekend.angel_cost - weekend.payments.where(person_id: self.id).team_fees.sum(:amount)
  end

  def total_donations(weekend_id)
    payments.by_weekend(weekend_id).donations.sum('amount')
  end

  def financial_assistance(weekend_id)
    attendance = self.attendees.by_weekend(weekend_id).first
    attendance.fa_amount_granted.to_f || 0
  end

  def total_payments(weekend_id)
    payments.by_weekend(weekend_id).sum('amount') + financial_assistance(weekend_id)
  end

  def has_outside_logs?
    self.outside_position_logs.where('person_id = ?', self.id).present?
  end

  def last_weekend_attended
    self.weekend_attendees.last || nil
  end

  def total_attendance_count
    self.weekend_attendees_count + self.outside_position_logs_count
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
    weekend = Weekend.next_weekend_for self[:gender]
    begin
      #event.event_attendees.map(&:person_id).includes? self.id
      weekend.attendees.where("person_id = ?", self.id).first
    rescue
      nil
    end
  end

  def last_attendance
    begin
      self.weekend_attendees.chronological(false).last
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
    self.weekend_attendees.first.update_attribute('last_minute', self.attend_last_minute) if self.candidate? && self.attend_last_minute_changed?
  end

end
