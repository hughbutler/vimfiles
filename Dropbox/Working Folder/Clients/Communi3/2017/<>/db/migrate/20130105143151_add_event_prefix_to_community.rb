class AddEventPrefixToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :event_prefix, :string
  end

  def self.down
    remove_column :communities, :event_prefix
  end
end
