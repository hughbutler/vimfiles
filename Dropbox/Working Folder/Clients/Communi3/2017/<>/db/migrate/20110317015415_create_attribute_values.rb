class CreateAttributeValues < ActiveRecord::Migration
  def self.up
    create_table :attribute_values do |t|
      t.string :value
      t.integer :attribute_id

      t.timestamps
    end
    add_index :attribute_values, :attribute_id
  end

  def self.down
    remove_index :attribute_values, :attribute_id
    drop_table :attribute_values
  end
end