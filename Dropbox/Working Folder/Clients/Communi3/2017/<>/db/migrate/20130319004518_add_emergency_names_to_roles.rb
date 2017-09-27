class AddEmergencyNamesToRoles < ActiveRecord::Migration
  def self.up
    add_column :nominations, :f_emergency_contact_name, :string
    add_column :nominations, :m_emergency_contact_name, :string
  end

  def self.down
    remove_column :nominations, :m_emergency_contact_name
    remove_column :nominations, :f_emergency_contact_name
  end
end
