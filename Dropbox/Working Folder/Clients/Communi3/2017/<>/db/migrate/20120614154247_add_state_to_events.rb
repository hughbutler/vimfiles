class AddStateToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :step, :string, :nil => false, :default => 'open'
  end

  def self.down
    remove_column :events, :step
  end
end
