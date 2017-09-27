class CreateNominations < ActiveRecord::Migration
  def self.up
    create_table :nominations do |t|
      t.integer :person_id
      t.integer :sponsorship_type_id
      t.string :main_phone
      t.string :street
      t.string :city
      t.integer :state_id
      t.string :postal
      t.boolean :is_accepted, :default => false
      t.string :m_first_name
      t.string :m_last_name
      t.date :m_birthdate
      t.string :m_mobile_phone
      t.string :m_email
      t.string :m_church_name
      t.boolean :m_is_clergy, :default => false
      t.text :m_notes
      t.boolean :m_wants_to_attend, :default => false
      t.integer :m_event_id
      t.string :f_first_name
      t.string :f_last_name
      t.date :f_birthdate
      t.string :f_mobile_phone
      t.string :f_email
      t.string :f_church_name
      t.boolean :f_is_clergy, :default => false
      t.text :f_notes
      t.boolean :f_wants_to_attend, :default => false
      t.integer :f_event_id
      
      t.integer :community_id
      t.string :who_pays
      t.boolean :is_married, :default => false
      t.string :spouse_name
      
      t.boolean :m_last_minute, :default => false
      t.boolean :f_last_minute, :default => false      

      t.timestamps
    end
    add_index :nominations, :community_id
    add_index :nominations, :person_id
    add_index :nominations, :sponsorship_type_id
    add_index :nominations, :m_event_id
    add_index :nominations, :f_event_id
  end

  def self.down
    drop_table :nominations
  end
end