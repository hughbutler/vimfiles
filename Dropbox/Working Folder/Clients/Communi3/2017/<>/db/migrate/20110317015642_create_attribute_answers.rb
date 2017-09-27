class CreateAttributeAnswers < ActiveRecord::Migration
  def self.up
    create_table :attribute_answers do |t|
      t.integer :attribute_id
      t.string :value
      t.integer :person_id
      t.integer :attributable_id, :integer
      t.string :attributable_type, :string

      t.timestamps
    end
    add_index :attribute_answers, :attribute_id
    add_index :attribute_answers, :attributable_id
    add_index :attribute_answers, :person_id
  end

  def self.down
    drop_table :attribute_answers
  end
end