class AddAuxPositionIdToEventAttendees < ActiveRecord::Migration
  def self.up
    add_column :event_attendees, :aux_position_id, :integer
    add_index :event_attendees, :aux_position_id
  end

  def self.down
    remove_column :event_attendees, :aux_position_id
    remove_index :event_attendees, :aux_position_id
  end
end
