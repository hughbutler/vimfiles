class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string :long
      t.string :short
    end
    
    State.create!( :long => "Alabama", :short => "AL" ) 
    State.create!( :long => "Alaska", :short => "AK" ) 
    State.create!( :long => "Arizona", :short => "AZ" ) 
    State.create!( :long => "Arkansas", :short => "AR" ) 
    State.create!( :long => "California", :short => "CA" ) 
    State.create!( :long => "Colorado", :short => "CO" ) 
    State.create!( :long => "Connecticut", :short => "CT" ) 
    State.create!( :long => "Delaware", :short => "DE" ) 
    State.create!( :long => "District Of Columbia", :short => "DC" ) 
    State.create!( :long => "Florida", :short => "FL" ) 
    State.create!( :long => "Georgia", :short => "GA" ) 
    State.create!( :long => "Hawaii", :short => "HI" ) 
    State.create!( :long => "Idaho", :short => "ID" ) 
    State.create!( :long => "Illinois", :short => "IL" ) 
    State.create!( :long => "Indiana", :short => "IN" ) 
    State.create!( :long => "Iowa", :short => "IA" ) 
    State.create!( :long => "Kansas", :short => "KS" ) 
    State.create!( :long => "Kentucky", :short => "KY" ) 
    State.create!( :long => "Louisiana", :short => "LA" ) 
    State.create!( :long => "Maine", :short => "ME" ) 
    State.create!( :long => "Maryland", :short => "MD" ) 
    State.create!( :long => "Massachusetts", :short => "MA" ) 
    State.create!( :long => "Michigan", :short => "MI" ) 
    State.create!( :long => "Minnesota", :short => "MN" ) 
    State.create!( :long => "Mississippi", :short => "MS" ) 
    State.create!( :long => "Missouri", :short => "MO" ) 
    State.create!( :long => "Montana", :short => "MT" ) 
    State.create!( :long => "Nebraska", :short => "NE" ) 
    State.create!( :long => "Nevada", :short => "NV" ) 
    State.create!( :long => "New Hampshire", :short => "NH" ) 
    State.create!( :long => "New Jersey", :short => "NJ" ) 
    State.create!( :long => "New Mexico", :short => "NM" ) 
    State.create!( :long => "New York", :short => "NY" ) 
    State.create!( :long => "North Carolina", :short => "NC" ) 
    State.create!( :long => "North Dakota", :short => "ND" ) 
    State.create!( :long => "Ohio", :short => "OH" ) 
    State.create!( :long => "Oklahoma", :short => "OK" ) 
    State.create!( :long => "Oregon", :short => "OR" ) 
    State.create!( :long => "Pennsylvania", :short => "PA" ) 
    State.create!( :long => "Rhode Island", :short => "RI" ) 
    State.create!( :long => "South Carolina", :short => "SC" ) 
    State.create!( :long => "South Dakota", :short => "SD" ) 
    State.create!( :long => "Tennessee", :short => "TN" ) 
    State.create!( :long => "Texas", :short => "TX" ) 
    State.create!( :long => "Utah", :short => "UT" ) 
    State.create!( :long => "Vermont", :short => "VT" ) 
    State.create!( :long => "Virginia", :short => "VA" ) 
    State.create!( :long => "Washington", :short => "WA" ) 
    State.create!( :long => "West Virginia", :short => "WV" ) 
    State.create!( :long => "Wisconsin", :short => "WI" ) 
    State.create!( :long => "Wyoming", :short => "WY" )
    
  end

  def self.down
    drop_table :states
  end
end
