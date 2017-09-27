# == Schema Information
#
# Table name: payments
#
#  id           :integer          not null, primary key
#  community_id :integer
#  person_id    :integer          not null
#  weekend_id     :integer
#  payment_type :string(255)      not null
#  amount       :decimal(10, 2)
#  deleted      :boolean          default(FALSE)
#  created_at   :datetime
#  updated_at   :datetime
#  note         :string(255)
#  source       :string(255)      default("self")
#  token        :string(255)
#

class Weekend::Payment < ApplicationRecord

    belongs_to :person
    belongs_to :weekend

    scope :event,               -> (id) { where(:weekend_id => id) }
    scope :fees_payment,        -> { where('payment_type = ? or payment_type = ? or payment_type = ?', 'attendance', 'lunch', 'donation') }
    scope :team_fees,           -> { where('payment_type = ?', 'team fees') }
    scope :donations,           -> { where('payment_type = ?', 'donation') }
    scope :scope_event,         -> (weekend_id) { where('weekend_id = ?', weekend_id) }
    scope :by_weekend,          -> (weekend_id) { where('weekend_id = ?', weekend_id) }
    default_scope               -> { order('created_at desc') }

    validates_presence_of :person_id, :weekend_id, :payment_type, :amount
    #validates_presence_of :token, if: :paying_online?

    def is_donation?
        self.payment_type.downcase == 'donation'
    end

    def general?
        self.source.downcase == 'general'
    end

    private

    def paying_online?
        self.source.downcase == 'online'
    end

end
