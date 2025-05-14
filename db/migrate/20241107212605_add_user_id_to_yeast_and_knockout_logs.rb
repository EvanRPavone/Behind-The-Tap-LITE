class AddUserIdToYeastAndKnockoutLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :yeast_and_knockout_logs, :user_id, :integer
    add_index :yeast_and_knockout_logs, :user_id
  end
end
