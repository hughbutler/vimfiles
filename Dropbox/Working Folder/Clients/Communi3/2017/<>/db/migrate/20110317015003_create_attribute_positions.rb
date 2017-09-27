class CreateAttributePositions < ActiveRecord::Migration
  def self.up
    create_table :attribute_positions do |t|
      t.string :title
      t.string :tag
    end
    
    attribute_positions = [ 
        { :tag => 'nominee', :title => 'Specific information about the person being nominated.' },
        { :tag => 'nominator', :title => 'Ask the sponsor on the nomination form.' },
        { :tag => 'attendee', :title => 'Ask when person is attending an event.' },
        { :tag => 'member', :title => 'A characteristic to a person in the system.' },
        { :tag => 'event', :title => 'A characteristic to an event.' }
      ]

    attribute_positions.each do |position|
      p = AttributePosition.where(:tag => position[:tag]) 
      if p.empty?
        p = AttributePosition.new
        p.tag = position[:tag]
        p.title = position[:title]
        p.save
      end
    end
    
  end

  def self.down
    drop_table :attribute_positions
  end
end
