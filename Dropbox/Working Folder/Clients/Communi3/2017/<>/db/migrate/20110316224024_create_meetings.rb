class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      t.integer :event_id
      t.integer :title
      t.timestamps
    end
    add_index :meetings, :event_id
  end

  def self.down
    remove_index :meetings, :event_id
    drop_table :meetings
  end
end