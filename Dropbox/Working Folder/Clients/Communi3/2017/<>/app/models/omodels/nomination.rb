# == Schema Information
#
# Table name: nominations
#
#  id                         :integer          not null, primary key
#  person_id                  :integer
#  sponsorship_type_id        :integer
#  main_phone                 :string(255)
#  street                     :string(255)
#  city                       :string(255)
#  state_id                   :integer
#  postal                     :string(255)
#  is_accepted                :boolean          default(FALSE)
#  m_first_name               :string(255)
#  m_last_name                :string(255)
#  m_birthdate                :date
#  m_mobile_phone             :string(255)
#  m_email                    :string(255)
#  m_church_name              :string(255)
#  m_is_clergy                :boolean          default(FALSE)
#  m_notes                    :text
#  m_wants_to_attend          :boolean          default(FALSE)
#  m_event_id                 :integer
#  f_first_name               :string(255)
#  f_last_name                :string(255)
#  f_birthdate                :date
#  f_mobile_phone             :string(255)
#  f_email                    :string(255)
#  f_church_name              :string(255)
#  f_is_clergy                :boolean          default(FALSE)
#  f_notes                    :text
#  f_wants_to_attend          :boolean          default(FALSE)
#  f_event_id                 :integer
#  community_id               :integer
#  who_pays                   :string(255)
#  is_married                 :boolean          default(FALSE)
#  spouse_name                :string(255)
#  m_last_minute              :boolean          default(FALSE)
#  f_last_minute              :boolean          default(FALSE)
#  created_at                 :datetime
#  updated_at                 :datetime
#  m_shirt_size               :string(255)
#  m_emergency_contact_number :string(255)
#  f_shirt_size               :string(255)
#  f_emergency_contact_number :string(255)
#  f_emergency_contact_name   :string(255)
#  m_emergency_contact_name   :string(255)
#

class Nomination < ActiveRecord::Base
  belongs_to :community
  belongs_to :sponsorship_type
  belongs_to :state
  belongs_to :person
  scope :by_community, lambda { |community_id| where('people.community_id = ?', community_id).joins(:person) }
  scope :approved, lambda { |*status| where('is_accepted = ?', (status.present?) ? status : true) }

  attr_accessor :address

  #validates_presence_of :state_id

  def is_single_man?
    sponsorship_title == 'male'
  end

  def is_single_woman?
    sponsorship_title == 'female'
  end

  def is_married_couple?
    sponsorship_title == 'married'
  end

  def address
    addr = ''
    addr+= "#{self.street},<br/>" if self.street.present?
    addr+= "#{self.city}, " if self.city.present?
    addr+= self.state.short if self.state.present?
    addr+= " #{self.postal}" if self.postal.present?
    addr
  end

  def explode_to_people
    @base_information = {
      :street => street,
      :city => city,
      :state_id => state_id,
      :main_phone => main_phone,
      :postal => postal,
      :nomination_id => id,
      :community_id => community_id,
      :parent_id => self.person_id,
      :who_pays => who_pays,
      :is_married => is_married,
      :spouse_name => spouse_name
    }
    @man = @female = nil
    unless is_single_woman?
      #man stuff
      @man_information = {
        :first_name => m_first_name,
        :last_name => m_last_name,
        :gender => 'male',
        :mobile_phone => m_mobile_phone,
        :wants_to_attend => m_wants_to_attend,
        :event_id => m_event_id,
        :notes => m_notes,
        :church_name => m_church_name,
        :is_clergy => m_is_clergy,
        :birthdate => m_birthdate,
        :email => m_email,
        :shirt_size => m_shirt_size,
        :emergency_contact_phone => m_emergency_contact_number,
        :emergency_contact_name => m_emergency_contact_name,
        :attend_last_minute => m_last_minute
      }

      @man = Person.create( @man_information.merge(@base_information) )
      EventAttendee.create(:person_id => @man.id, :event_id => @man.event_id, :position_id => 0, :attended => false, :last_minute => m_last_minute )
    end
    unless is_single_man?
      #female stuff
      @female_information = {
        :first_name => f_first_name,
        :last_name => f_last_name,
        :gender => 'female',
        :mobile_phone => f_mobile_phone,
        :wants_to_attend => f_wants_to_attend,
        :event_id => f_event_id,
        :notes => f_notes,
        :church_name => f_church_name,
        :is_clergy => f_is_clergy,
        :birthdate => f_birthdate,
        :email => f_email,
        :shirt_size => f_shirt_size,
        :emergency_contact_phone => f_emergency_contact_number,
        :emergency_contact_name => f_emergency_contact_name,
        :attend_last_minute => f_last_minute
      }

      @female = Person.create(@female_information.merge(@base_information))
      EventAttendee.create(:person_id => @female.id, :event_id => @female.event_id, :position_id => 0, :attended => false, :last_minute => f_last_minute )
    end
    if is_married_couple?
      Marriage.create(:person_id_male => @man.id, :person_id_female => @female.id)
    end

  end

  private

  def sponsorship_title
    if self.sponsorship_type_id.present?
      sponsorship = SponsorshipType.find(self.sponsorship_type_id)
      sponsorship.tag
    else
      false
    end
  end
end
