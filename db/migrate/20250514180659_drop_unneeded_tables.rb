class DropUnneededTables < ActiveRecord::Migration[7.1]
  def change
    drop_table :users
    drop_table :invitations
    remove_column :addition_logs, :user_id
    remove_column :boil_logs, :user_id
    remove_column :fermentation_logs, :user_id
    remove_column :mash_logs, :user_id
    remove_column :yeast_and_knockout_logs, :user_id
  end
end
