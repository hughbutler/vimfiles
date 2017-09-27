class CreateMemberStatuses < ActiveRecord::Migration
  def self.up
    create_table :member_statuses do |t|
      t.string :title
      t.string :tag
    end
    
    MemberStatus.create!(:tag => 'nominee', :title => 'Nominated')
    MemberStatus.create!(:tag => 'attendee', :title => 'Scheduled for an Event')
    MemberStatus.create!(:tag => 'member', :title => 'Full Member')
    MemberStatus.create!(:tag => 'admin', :title => 'Community Admin')
    MemberStatus.create!(:tag => 'sysad', :title => 'System Admin')
    
  end

  def self.down
    drop_table :member_statuses
  end
end
