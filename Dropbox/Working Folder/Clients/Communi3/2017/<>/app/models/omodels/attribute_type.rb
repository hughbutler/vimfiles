# == Schema Information
#
# Table name: attribute_types
#
#  id    :integer          not null, primary key
#  title :string(255)
#  tag   :string(255)
#

class AttributeType < ActiveRecord::Base
  has_many :attributes
end
