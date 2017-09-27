# == Schema Information
#
# Table name: attribute_types
#
#  id    :integer          not null, primary key
#  title :string(255)
#  tag   :string(255)
#

class Attribute::Type < ApplicationRecord
  has_many :custom_fields, class_name: 'Attribute'
end
