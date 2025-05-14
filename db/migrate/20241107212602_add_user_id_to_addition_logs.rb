class AddUserIdToAdditionLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :addition_logs, :user_id, :integer
    add_index :addition_logs, :user_id
  end
end
