class CreateCommunities < ActiveRecord::Migration
  def self.up
    create_table :communities do |t|

      t.string :title
      t.string :street
      t.string :city
      t.integer :state_id
      t.string :postal
      t.string :phone
      t.string :email
      t.string :url
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :communities
  end
end
