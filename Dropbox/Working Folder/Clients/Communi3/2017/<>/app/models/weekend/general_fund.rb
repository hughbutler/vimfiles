# == Schema Information
#
# Table name: general_funds
#
#  id         :integer          not null, primary key
#  event_id   :integer          not null
#  amount     :decimal(8, 2)    not null
#  note       :string(255)
#  person_id  :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class Weekend::GeneralFund < ApplicationRecord
    belongs_to :weekend
    belongs_to :person

    attr_accessor :applying_funds, :url

    def credit?
        self[:amount] > 0
    end

    def debit?
        self[:amount] < 0
    end
end
