class AddFieldsToNominations < ActiveRecord::Migration
  def self.up
    add_column :nominations, :m_shirt_size, :string
    add_column :nominations, :m_emergency_contact_number, :string
    add_column :nominations, :f_shirt_size, :string
    add_column :nominations, :f_emergency_contact_number, :string
  end

  def self.down
    remove_column :nominations, :f_emergency_contact_number
    remove_column :nominations, :m_emergency_contact_number
    remove_column :nominations, :f_shirt_size
    remove_column :nominations, :m_shirt_size
  end
end
