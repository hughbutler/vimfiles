class CreateAttributeTypes < ActiveRecord::Migration
  def self.up
    create_table :attribute_types do |t|
      t.string :title
      t.string :tag
    end
    
    attribute_types = [ 
        { :tag => 'textarea', :title => 'Person may type a long answer. (Large Textbox)' },
        { :tag => 'input', :title => 'Person may type a short answer. (Small Textbox)' },
        { :tag => 'select', :title => 'Person is given answers to choose from. (Select/Dropdown)' }
      ]

    attribute_types.each do |type|
      t = AttributeType.where(:tag => type[:tag])
      if t.empty?
        t = AttributeType.new
        t.tag = type[:tag]
        t.title = type[:title]
        t.save
      end
    end
    
  end

  def self.down
    drop_table :attribute_types
  end
end