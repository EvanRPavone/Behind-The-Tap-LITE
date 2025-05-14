class AddNotesToMashLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :mash_logs, :notes, :text
  end
end
