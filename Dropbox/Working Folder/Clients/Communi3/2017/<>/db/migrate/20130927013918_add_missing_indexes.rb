class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :people, :parent_id
    add_index :people, :state_id
    add_index :users, :person_id
    add_index :nominations, :state_id
    add_index :events, :coordinator_id
    add_index :events, :spiritual_director_id
    add_index :events, :state_id
    add_index :positions, :community_id
    add_index :general_funds, :person_id
    add_index :communities, :state_id
    add_index :attribute_answers, [:attributable_id, :attributable_type]
    add_index :payments, :person_id
    add_index :payments, :event_id
  end
end
