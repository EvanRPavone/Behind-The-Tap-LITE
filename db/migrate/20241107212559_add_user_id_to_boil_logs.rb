class AddUserIdToBoilLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :boil_logs, :user_id, :integer
    add_index :boil_logs, :user_id
  end
end
