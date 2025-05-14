class AddOgWasAndOgIsToFermentationLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :fermentation_logs, :og_was, :decimal
    add_column :fermentation_logs, :og_is, :decimal
  end
end
