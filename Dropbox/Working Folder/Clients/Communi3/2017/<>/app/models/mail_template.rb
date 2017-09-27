# == Schema Information
#
# Table name: mail_templates
#
#  id           :integer          not null, primary key
#  community_id :integer
#  blurb        :text
#  context      :string(255)
#  subject      :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  from_address :string(255)
#

class MailTemplate < ApplicationRecord

  belongs_to :community

  scope :by_community, -> (community_id) { where('community_id = ?', community_id) }
  scope :context,      -> (context) { where('context = ?', context) }

  def to_s
    self.context.gsub('_', ' ').upcase{}
  end

end
