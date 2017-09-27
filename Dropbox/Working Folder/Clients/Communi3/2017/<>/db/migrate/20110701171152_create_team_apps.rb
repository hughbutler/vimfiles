class CreateTeamApps < ActiveRecord::Migration
  def self.up
    create_table :team_apps do |t|
      t.integer :person_id
      t.integer :event_id
      t.boolean :will_attend_meetings, :default => true
      t.boolean :living_lifestyle, :default => false
      t.boolean :is_scheduled, :default => false

      t.timestamps
    end
    
    add_index :team_apps, :person_id
    add_index :team_apps, :event_id
  end

  def self.down
    drop_table :team_apps
  end
end
