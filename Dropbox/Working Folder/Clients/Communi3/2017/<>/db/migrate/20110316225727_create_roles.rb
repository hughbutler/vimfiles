class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :long
      t.string :short
      t.integer :sort, :null => false
      t.timestamps
    end

    Role.create!( :long => "Super Admin",         :short => "super_admin",        :sort => 10 )
    Role.create!( :long => "Rector",              :short => "rector",             :sort => 20 )
    Role.create!( :long => "Pre Weekend Couple",  :short => "pre_weekend_couple", :sort => 30 )
    Role.create!( :long => "Core Team",           :short => "core",               :sort => 40 )
    Role.create!( :long => "Leader",              :short => "leader",             :sort => 50 )
    Role.create!( :long => "4th Day Couple",      :short => "fourth_day_couple",  :sort => 60 )

  end

  def self.down
    drop_table :roles
  end
end
