class AddBirthEventAltToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :birth_event_alt, :string
  end

  def self.down
    remove_column :people, :birth_event_alt
  end
end
