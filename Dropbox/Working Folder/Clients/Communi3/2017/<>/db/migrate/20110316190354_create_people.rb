class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :gender
      t.string :name_on_tag
      t.string :street
      t.string :city
      t.integer :state_id
      t.string :postal
      t.string :main_phone
      t.string :mobile_phone
      t.boolean :is_married
      t.string :spouse_name
      t.string :emergency_contact_name
      t.string :emergency_contact_phone
      t.string :church_name
      t.boolean :is_clergy, :default => false
      t.date :birthdate
      t.string :who_pays
      t.text :notes
      t.integer :member_status_id, :default => 1
      t.boolean :wants_to_attend, :default => false
      t.integer :community_id
      t.integer :event_id
      t.integer :role_id
      t.integer :nomination_id
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt

      t.integer :event_attendees_count, :default => 0
      t.integer :meeting_attendees_count, :default => 0
      t.integer :outside_position_logs_count, :default => 0

      t.timestamps
    end
    
    add_index :people, :member_status_id
    add_index :people, :community_id
    add_index :people, :event_id
    add_index :people, :role_id
    add_index :people, :nomination_id
  end

  def self.down
    drop_table :people
  end
end
