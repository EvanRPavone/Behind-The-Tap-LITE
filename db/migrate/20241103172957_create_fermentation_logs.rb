class CreateFermentationLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :fermentation_logs do |t|
      t.references :brew, null: false, foreign_key: true
      t.string :status
      t.decimal :temperature
      t.decimal :ph
      t.datetime :log_date

      t.timestamps
    end
  end
end
