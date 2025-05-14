class AddNotesToYeastAndKnockoutLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :yeast_and_knockout_logs, :notes, :text
  end
end
