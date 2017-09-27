# == Schema Information
#
# Table name: attribute_positions
#
#  id    :integer          not null, primary key
#  title :string(255)
#  tag   :string(255)
#

class Attribute::Position < ApplicationRecord
  has_many :custom_fields, class_name: 'Attribute'
end
