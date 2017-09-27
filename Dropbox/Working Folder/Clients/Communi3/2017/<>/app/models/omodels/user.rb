# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  email                :string(255)      default(""), not null
#  encrypted_password   :string(128)      default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer          default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  person_id            :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class User < ActiveRecord::Base
  belongs_to :person
  has_many :nominations, :through => :person
  delegate :gender, :events, :community, :to => :person

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :person_id, :remember_me

  def admin?
    self.person.role.present? && self.person.role.to_s == 'super_admin'
  end

  def can_see_all_events?
    roles = [ 'super_admin', 'pre_weekend_couple', 'fourth_day_couple' ]
    roles.include? self.person.try(:role).to_s
  end

end