# == Schema Information
#
# Table name: attribute_answers
#
#  id                :integer          not null, primary key
#  attribute_id      :integer
#  title             :string(255)
#  person_id         :integer
#  attributable_id   :integer
#  integer           :integer
#  attributable_type :string(255)
#  string            :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class Attribute::Answer < ApplicationRecord

  # Associations
  belongs_to :person
  belongs_to :base_attribute, class_name: 'Attribute'
  belongs_to :attributable, :polymorphic => true

  scope :by_community,      -> (community_id) { where('attributes.community_id = ?', community_id).joins(:base_attribute) }
  scope :by_position,       -> (tag_string) { where('lower(attribute_positions.tag) = ?', tag_string.downcase).joins(:base_attribute => :attribute_position) }

  def to_s
    self[:title]
  end

end
