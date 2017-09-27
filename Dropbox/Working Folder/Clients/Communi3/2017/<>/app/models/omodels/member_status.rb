# == Schema Information
#
# Table name: member_statuses
#
#  id    :integer          not null, primary key
#  title :string(255)
#  tag   :string(255)
#

class MemberStatus < ActiveRecord::Base
  has_many :people
end
