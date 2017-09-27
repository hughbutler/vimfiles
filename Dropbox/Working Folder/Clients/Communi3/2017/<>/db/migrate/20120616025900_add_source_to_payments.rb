class AddSourceToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :source, :string, :nil => false, :default => 'self'
    Payment.update_all( "source = 'self'" )
    add_index :payments, :source
  end

  def self.down
    remove_column :payments, :source
  end
end
