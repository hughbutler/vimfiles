class AddActiveToEventAttendees < ActiveRecord::Migration
  def self.up
    add_column :event_attendees, :active, :boolean, :nil => false, :default => true
    #EventAttendee.update_all( "active = true" )
  end

  def self.down
    remove_column :event_attendees, :active
  end
end
