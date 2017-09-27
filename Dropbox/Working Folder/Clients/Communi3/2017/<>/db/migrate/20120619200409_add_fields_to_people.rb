class AddFieldsToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :shirt_size, :string
    add_column :people, :sponsorship_training, :string
  end

  def self.down
    remove_column :people, :sponsorship_training
    remove_column :people, :shirt_size
  end
end
