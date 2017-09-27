# == Schema Information
#
# Table name: attribute_positions
#
#  id    :integer          not null, primary key
#  title :string(255)
#  tag   :string(255)
#

class AttributePosition < ActiveRecord::Base
  has_many :attributes
  attr_accessible :id, :name, :tag
end
