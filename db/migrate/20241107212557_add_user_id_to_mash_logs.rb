class AddUserIdToMashLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :mash_logs, :user_id, :integer
    add_index :mash_logs, :user_id
  end
end
