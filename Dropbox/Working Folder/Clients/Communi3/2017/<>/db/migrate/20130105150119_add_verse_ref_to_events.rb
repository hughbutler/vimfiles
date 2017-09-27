class AddVerseRefToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :verse_reference, :string
    change_column :events, :verse, :text
  end

  def self.down
    remove_column :events, :verse_reference
    change_column :events, :verse, :string
  end
end
