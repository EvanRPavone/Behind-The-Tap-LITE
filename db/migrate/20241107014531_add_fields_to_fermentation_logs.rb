class AddFieldsToFermentationLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :fermentation_logs, :user_id, :integer
    add_column :fermentation_logs, :stage, :string
    add_column :fermentation_logs, :day, :integer
    add_column :fermentation_logs, :plato, :decimal
    add_column :fermentation_logs, :tank_temp, :decimal
    add_column :fermentation_logs, :action, :string
    add_column :fermentation_logs, :notes, :text
  end
end
