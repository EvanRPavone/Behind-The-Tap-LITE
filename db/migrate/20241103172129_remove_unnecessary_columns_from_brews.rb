# db/migrate/xxxxxx_remove_unnecessary_columns_from_brews.rb
class RemoveUnnecessaryColumnsFromBrews < ActiveRecord::Migration[7.1]
  def change
    remove_column :brews, :next_steps_id, :integer
    remove_column :brews, :int_sg, :decimal, default: 1.0
    remove_column :brews, :og_was, :decimal
    remove_column :brews, :og_is, :decimal
    remove_column :brews, :current_sg, :decimal, default: 1.0
    remove_column :brews, :est_abv, :decimal
    remove_column :brews, :target_abv, :decimal
  end
end
