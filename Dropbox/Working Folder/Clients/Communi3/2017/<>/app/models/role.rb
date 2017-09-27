# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  long       :string(255)
#  short      :string(255)
#  sort       :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class Role < ApplicationRecord
  has_many :people

  # Scope
  default_scope { order(sort: :asc) }

  def to_s
    self[:short]
  end
end
