class CreateAdditionLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :addition_logs do |t|
      t.references :brew, null: false, foreign_key: true
      t.string :hop_addition_1
      t.string :hop_addition_2
      t.string :other_additions

      t.timestamps
    end
  end
end
