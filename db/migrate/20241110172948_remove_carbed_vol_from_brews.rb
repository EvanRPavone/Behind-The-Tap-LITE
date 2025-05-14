class RemoveCarbedVolFromBrews < ActiveRecord::Migration[7.1]
  def change
    remove_column :brews, :carbed_vol, :decimal
  end
end
