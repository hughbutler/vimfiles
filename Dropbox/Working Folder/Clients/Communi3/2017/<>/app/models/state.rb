# == Schema Information
#
# Table name: states
#
#  id    :integer          not null, primary key
#  long  :string(255)
#  short :string(255)
#

class State < ApplicationRecord
  has_many :people
  has_many :nominations
  has_many :events
  has_many :communities
end
