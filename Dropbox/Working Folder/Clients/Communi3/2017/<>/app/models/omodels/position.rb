# == Schema Information
#
# Table name: positions
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  community_id :integer
#  category_1   :boolean          default(FALSE)
#  category_2   :boolean          default(FALSE)
#  category_3   :boolean          default(FALSE)
#  category_4   :boolean          default(FALSE)
#  deleted      :boolean          default(FALSE)
#  created_at   :datetime
#  updated_at   :datetime
#

class Position < ActiveRecord::Base
  validates_presence_of :title

  has_many            :event_attendees
  has_many            :outside_position_logs

  belongs_to          :community

  scope               :community, lambda { |community_id| where('community_id = ? and deleted = ?', community_id, false).order('title') }
  scope               :category_1, where('category_1 = ?', true)
  scope               :category_2, where('category_2 = ?', true)
  scope               :category_3, where('category_3 = ?', true)
  scope               :category_4, where('category_4 = ?', true)

  before_create       :set_community

  def to_s
    self.title.present? ? self.title : 'Candidate'
  end

  def category
    "Category 1" if self.category_1? and !self.category_2? and !self.category_3?
    "Category 2" if self.category_1? and self.category_2? and !self.category_3?
    "Category 3" if self.category_1? and self.category_2? and self.category_3?
    "Category 4" if self.category_1? and self.category_2? and self.category_3? and self.category_4?
  end

  def self.categories
    cat_array = Array.new
    cat_array << ['Category 1', self.category_1]
    cat_array << ['Category 2', self.category_2]
    cat_array << ['Category 3', self.category_3]
    cat_array << ['Category 4', self.category_4]
    cat_array
  end

  private

  def set_community
    community_id = :community_id
  end
end
