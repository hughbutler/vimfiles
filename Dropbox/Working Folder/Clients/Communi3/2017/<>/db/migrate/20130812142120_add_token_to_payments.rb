class AddTokenToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :token, :string
  end

  def self.down
    remove_column :payments, :token
  end
end
