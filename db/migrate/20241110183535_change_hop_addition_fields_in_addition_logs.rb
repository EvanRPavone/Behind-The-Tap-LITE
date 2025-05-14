class ChangeHopAdditionFieldsInAdditionLogs < ActiveRecord::Migration[7.1]
  def change
    # Rename columns first
    rename_column :addition_logs, :hop_addition_1, :hop_addition_1_id
    rename_column :addition_logs, :hop_addition_2, :hop_addition_2_id

    # Change the data type using explicit casting
    change_column :addition_logs, :hop_addition_1_id, 'bigint USING hop_addition_1_id::bigint'
    change_column :addition_logs, :hop_addition_2_id, 'bigint USING hop_addition_2_id::bigint'

    # Add foreign keys
    add_foreign_key :addition_logs, :ingredients, column: :hop_addition_1_id
    add_foreign_key :addition_logs, :ingredients, column: :hop_addition_2_id
  end
end
