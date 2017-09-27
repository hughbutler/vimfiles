class AddQueueFieldsToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :attend_last_minute, :boolean, :default => false, :nil => false
    add_column :people, :has_paid, :boolean, :default => false, :nil => false
  end

  def self.down
    remove_column :people, :has_paid
    remove_column :people, :attend_last_minute
  end
end
