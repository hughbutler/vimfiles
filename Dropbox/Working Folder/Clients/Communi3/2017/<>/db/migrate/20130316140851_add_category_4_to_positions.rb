class AddCategory4ToPositions < ActiveRecord::Migration
  def self.up
    add_column :positions, :category_4, :boolean, :default => false
  end

  def self.down
    remove_column :positions, :category_4
  end
end
