class CreateGeneralFunds < ActiveRecord::Migration
  def self.up
    create_table :general_funds do |t|
      t.integer :event_id,        :null => false
      t.decimal :amount,          :precision => 8, :scale => 2, :null => false
      t.string :note
      t.integer :person_id,       :null => false

      t.timestamps
    end

    add_index   :general_funds,  :event_id

  end

  def self.down
    drop_table :general_funds
  end
end
