class ChangeDefaultMemberStatusId < ActiveRecord::Migration
  def self.up
    change_column :people, :member_status_id, :integer
  end

  def self.down
    change_column :people, :member_status_id, :integer, :default => 1
  end
end
