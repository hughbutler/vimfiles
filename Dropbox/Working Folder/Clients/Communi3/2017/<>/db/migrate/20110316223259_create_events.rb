class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.date :start_date
      t.date :end_date
      t.string :location_name
      t.string :street
      t.string :city
      t.integer :state_id
      t.string :postal
      t.integer :coordinator_id
      t.integer :community_id
      t.text :details
      t.integer :attendee_cost
      t.integer :angel_cost
      t.string :gender
      t.string :verse

      t.timestamps
    end

    add_index :events, :community_id
  end

  def self.down
    remove_index :events, :community_id
    drop_table :events
  end
end
