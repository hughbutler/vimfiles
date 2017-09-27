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

class Nominee < Person
  def find_by_nomination( nomination )
    
  end
end
