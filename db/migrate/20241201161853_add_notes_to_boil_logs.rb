class AddNotesToBoilLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :boil_logs, :notes, :text
  end
end
