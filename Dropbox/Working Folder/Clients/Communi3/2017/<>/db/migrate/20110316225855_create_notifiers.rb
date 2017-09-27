class CreateNotifiers < ActiveRecord::Migration
  def self.up
    create_table :notifiers do |t|
      t.integer :role_id
      t.string :action

      t.timestamps
    end
    add_index :notifiers, :role_id
  end

  def self.down
    remove_index :notifiers, :role_id
    drop_table :notifiers
  end
end