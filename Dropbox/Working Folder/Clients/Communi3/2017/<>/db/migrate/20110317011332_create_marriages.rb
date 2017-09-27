class CreateMarriages < ActiveRecord::Migration
  def self.up
    create_table :marriages do |t|
      t.integer :person_id_male
      t.integer :person_id_female

      t.timestamps
    end
    add_index :marriages, :person_id_male
    add_index :marriages, :person_id_female
  end

  def self.down
    remove_index :marriages, :person_id_male
    remove_index :marriages, :person_id_female
    
    drop_table :marriages
  end
end