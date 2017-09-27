class CreateMeetingAttendees < ActiveRecord::Migration
  def self.up
    create_table :meeting_attendees do |t|
      t.integer :meeting_id
      t.integer :person_id

      t.timestamps
    end
    add_index :meeting_attendees, :meeting_id
    add_index :meeting_attendees, :person_id
  end

  def self.down
    remove_index :meeting_attendees, :person_id
    remove_index :meeting_attendees, :meeting_id
    drop_table :meeting_attendees
  end
end