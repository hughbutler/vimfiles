# == Schema Information
#
# Table name: notifiers
#
#  id         :integer          not null, primary key
#  role_id    :integer
#  action     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Notifier < ActiveRecord::Base
end
