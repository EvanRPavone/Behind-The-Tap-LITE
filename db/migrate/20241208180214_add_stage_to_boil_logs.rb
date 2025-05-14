class AddStageToBoilLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :boil_logs, :stage, :string, null: false, default: 'preboil'
  end
end
