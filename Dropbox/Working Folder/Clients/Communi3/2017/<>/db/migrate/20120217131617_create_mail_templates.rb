class CreateMailTemplates < ActiveRecord::Migration
  def self.up
    create_table :mail_templates do |t|
      t.integer :community_id
      t.text :blurb
      t.string :context
      t.string :subject

      t.timestamps
    end

    add_index :mail_templates, :community_id
  end

  def self.down
    drop_table :mail_templates
  end
end
