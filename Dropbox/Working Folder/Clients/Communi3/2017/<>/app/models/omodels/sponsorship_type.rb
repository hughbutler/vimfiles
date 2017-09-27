# == Schema Information
#
# Table name: sponsorship_types
#
#  id    :integer          not null, primary key
#  title :string(255)
#  tag   :string(255)
#

class SponsorshipType < ActiveRecord::Base
  has_many :nominations
end
