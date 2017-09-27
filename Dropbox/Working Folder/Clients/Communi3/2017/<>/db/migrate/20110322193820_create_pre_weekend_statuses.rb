class CreatePreWeekendStatuses < ActiveRecord::Migration
  def self.up
    create_table :pre_weekend_statuses do |t|
      t.string :title
      t.string :tag
    end

    PreWeekendStatus.create!( :tag => 'not_invited', :title => 'Not Yet Invited' )
    PreWeekendStatus.create!( :tag => 'invited', :title => 'Has Been Invited' )
    PreWeekendStatus.create!( :tag => 'accepted', :title => 'Accepted Invitation' )
    PreWeekendStatus.create!( :tag => 'declinded', :title => 'Declined Invitation' )
    PreWeekendStatus.create!( :tag => 'protected', :title => 'Postponed (Protected)' )

  end

  def self.down
    drop_table :pre_weekend_statuses
  end
end
