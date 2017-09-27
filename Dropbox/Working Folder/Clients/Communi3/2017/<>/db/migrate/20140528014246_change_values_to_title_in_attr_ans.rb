class ChangeValuesToTitleInAttrAns < ActiveRecord::Migration
  def self.up
    rename_column :attribute_answers, :value, :title
  end

  def self.down
    rename_column :attribute_answers, :title, :value
  end
end
