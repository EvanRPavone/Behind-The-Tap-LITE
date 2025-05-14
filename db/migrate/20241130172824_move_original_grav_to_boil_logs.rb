class MoveOriginalGravToBoilLogs < ActiveRecord::Migration[7.1]
  def change
    remove_column :brews, :original_grav, :decimal
    add_column :boil_logs, :original_grav, :decimal, precision: 5, scale: 3
  end
end
