class AddBrewFieldsForPhase1ToBrews < ActiveRecord::Migration[7.1]
  def change
    add_column :brews, :int_sg, :decimal, precision: 5, scale: 3, default: 1.000
    add_column :brews, :current_sg, :decimal, precision: 5, scale: 3, default: 1.000
    add_column :brews, :est_abv, :decimal, precision: 5, scale: 2
    add_column :brews, :target_carbed_vol, :decimal, precision: 5, scale: 2
  end
end
