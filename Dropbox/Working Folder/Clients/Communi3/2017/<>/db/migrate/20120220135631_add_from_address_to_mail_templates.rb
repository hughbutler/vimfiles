class AddFromAddressToMailTemplates < ActiveRecord::Migration
  def self.up
    add_column :mail_templates, :from_address, :string
  end

  def self.down
    remove_column :mail_templates, :from_address
  end
end
