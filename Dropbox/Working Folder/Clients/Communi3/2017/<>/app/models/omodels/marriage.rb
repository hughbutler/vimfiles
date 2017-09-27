# == Schema Information
#
# Table name: marriages
#
#  id               :integer          not null, primary key
#  person_id_male   :integer
#  person_id_female :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Marriage < ActiveRecord::Base
  belongs_to :husband, :class_name => 'Person', :foreign_key => "person_id_male"
  belongs_to :wife, :class_name => 'Person', :foreign_key => "person_id_female"  
end
