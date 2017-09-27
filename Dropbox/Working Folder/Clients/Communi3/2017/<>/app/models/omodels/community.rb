# == Schema Information
#
# Table name: communities
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  street       :string(255)
#  city         :string(255)
#  state_id     :integer
#  postal       :string(255)
#  phone        :string(255)
#  email        :string(255)
#  url          :string(255)
#  active       :boolean
#  created_at   :datetime
#  updated_at   :datetime
#  event_prefix :string(255)
#

class Community < ActiveRecord::Base
  has_many :people
  has_many :nominations
  has_many :positions
  has_many :email_templates
  has_many :events
  has_many :event_attendees, :through => :events
  has_many :outside_position_logs, :through => :people

  belongs_to :state

  attr_accessible :title, :street, :city, :state_id, :postal, :phone, :email, :url, :active, :event_prefix

  def to_s
    self[:title]
  end

  def friendly_url
    self[:url].gsub('http://','').gsub('https://','').gsub('www.','')
  end

  def rectors(gender)
    people.scope_gender(gender).joins(:role).where("roles.short = 'rector'")
  end

end
