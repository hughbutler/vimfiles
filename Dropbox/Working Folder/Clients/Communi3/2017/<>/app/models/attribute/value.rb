# == Schema Information
#
# Table name: attribute_values
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  attribute_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Attribute::Value < ApplicationRecord
  belongs_to :custom_field, foreign_key: 'attribute_id', class_name: 'Attribute'
end
