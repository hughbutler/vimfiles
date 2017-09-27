class AddClosedToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :closed, :boolean, :nil => false, :default => false
    Event.update_all( "closed = false" )
  end

  def self.down
    remove_column :events, :closed
  end
end
