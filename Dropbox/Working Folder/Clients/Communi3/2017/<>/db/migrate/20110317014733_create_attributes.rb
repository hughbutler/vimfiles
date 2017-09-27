class CreateAttributes < ActiveRecord::Migration
  def self.up
    create_table :attributes do |t|
      t.string :title
      t.string :hint_field
      t.boolean :is_searchable
      t.integer :attribute_type_id
      t.integer :community_id
      t.integer :attribute_position_id

      t.timestamps
    end
    add_index :attributes, :attribute_type_id
    add_index :attributes, :community_id
    add_index :attributes, :attribute_position_id
  end

  def self.down
    remove_index :attributes, :attribute_position_id
    remove_index :attributes, :community_id
    remove_index :attributes, :attribute_type_id
    drop_table :attributes
  end
end