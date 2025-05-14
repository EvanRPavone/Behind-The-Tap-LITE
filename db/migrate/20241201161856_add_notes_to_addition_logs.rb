class AddNotesToAdditionLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :addition_logs, :notes, :text
  end
end
