class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :community_id, :nulll => false
      t.integer :person_id, :null => false
      t.integer :event_id
      t.string :payment_type, :null => false
      t.decimal :amount, :precision => 10, :scale => 2 
      t.boolean :deleted, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
