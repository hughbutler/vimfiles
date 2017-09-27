class CreateOutsidePositionLogs < ActiveRecord::Migration
  def self.up
    create_table :outside_position_logs do |t|
      t.string :community
      t.string :weekend
      t.integer :position_id
      t.integer :person_id

      t.timestamps
    end
    add_index :outside_position_logs, :position_id
    add_index :outside_position_logs, :person_id
  end

  def self.down
    remove_index :outside_position_logs, :person_id
    remove_index :outside_position_logs, :position_id
    drop_table :outside_position_logs
  end
end