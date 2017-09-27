class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    ## Recoverable
    add_column :users, :reset_password_sent_at, :datetime

    ## Lockable
    add_column :users, :failed_attempts, :integer, default: 0, null: false # Only if lock strategy is :failed_attempts
    add_column :users, :unlock_token, :string
    add_column :users, :locked_at, :datetime

    add_index :users, :unlock_token, unique: true
  end
end
