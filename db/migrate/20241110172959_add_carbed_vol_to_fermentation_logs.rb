class AddCarbedVolToFermentationLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :fermentation_logs, :carbed_vol, :decimal
  end
end
