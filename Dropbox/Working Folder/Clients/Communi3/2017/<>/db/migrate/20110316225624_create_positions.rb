class CreatePositions < ActiveRecord::Migration
  def self.up
    create_table :positions do |t|
      t.string :title
      t.integer :community_id
      t.boolean :category_1, :default => false
      t.boolean :category_2, :default => false
      t.boolean :category_3, :default => false
      t.boolean :deleted, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :positions
  end
end