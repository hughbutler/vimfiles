class CreateSponsorshipTypes < ActiveRecord::Migration
  def self.up
    create_table :sponsorship_types do |t|
      t.string :title
      t.string :tag
    end
    
    SponsorshipType.create!(:tag => 'male', :title => 'Single Man')
    SponsorshipType.create!(:tag => 'female', :title => 'Single Woman')
    SponsorshipType.create!(:tag => 'married', :title => 'Married Couple')
    
  end

  def self.down
    drop_table :sponsorship_types
  end
end
