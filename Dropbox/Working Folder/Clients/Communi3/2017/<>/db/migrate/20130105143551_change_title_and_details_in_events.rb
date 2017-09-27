class ChangeTitleAndDetailsInEvents < ActiveRecord::Migration
  def self.up
    rename_column :events, :title, :weekend_number
    rename_column :events, :details, :theme
  end

  def self.down
    rename_column :events, :weekend_number, :title
    rename_column :events, :theme, :details
  end
end
