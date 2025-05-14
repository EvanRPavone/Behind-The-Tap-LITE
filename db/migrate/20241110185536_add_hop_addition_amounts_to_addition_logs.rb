class AddHopAdditionAmountsToAdditionLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :addition_logs, :hop_addition_1_amount, :decimal, precision: 10, scale: 2
    add_column :addition_logs, :hop_addition_2_amount, :decimal, precision: 10, scale: 2
  end
end
