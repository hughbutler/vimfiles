class ChangeValuesToTitleInAttr < ActiveRecord::Migration
  def self.up
    rename_column :attribute_values, :value, :title
  end

  def self.down
    rename_column :attribute_values, :title, :value
  end
end
