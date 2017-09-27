# == Schema Information
#
# Table name: outside_position_logs
#
#  id          :integer          not null, primary key
#  community   :string(255)
#  weekend     :string(255)
#  position_id :integer
#  person_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class OutsidePositionLog < ActiveRecord::Base
  belongs_to                :person, :counter_cache => true
  belongs_to                :position

  validates_presence_of     :person_id,
                            :community,
                            :weekend
  validates_uniqueness_of :weekend, :scope => [ :position_id, :person_id ]

  def to_s
    "#{self.community} #{self.weekend}"
  end

  def position_title
    if position
      position_id == -1 ? 'Candidate' : position.title
    end
  end

end
