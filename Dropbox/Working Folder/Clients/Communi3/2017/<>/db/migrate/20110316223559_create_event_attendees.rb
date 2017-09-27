class CreateEventAttendees < ActiveRecord::Migration
  def self.up
    create_table :event_attendees do |t|
      t.integer :person_id
      t.integer :position_id
      t.integer :event_id
      t.boolean :attended, :default => true
      t.boolean :fa_needed, :default => false
      t.string :fa_amount_needed
      t.boolean :fa_granted, :default => false
      t.string :fa_amount_granted
      t.integer :pre_weekend_status_id, :default => 1
      t.boolean :last_minute, :default => false
      t.timestamps
    end
    add_index :event_attendees, :person_id
    add_index :event_attendees, :position_id
    add_index :event_attendees, :event_id
    add_index :event_attendees, :pre_weekend_status_id
  end

  def self.down
    remove_index :event_attendees, :person_id
    drop_table :event_attendees
  end
end
