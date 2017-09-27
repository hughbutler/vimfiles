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

class AttributeValue < ActiveRecord::Base
  belongs_to :attribute
end
