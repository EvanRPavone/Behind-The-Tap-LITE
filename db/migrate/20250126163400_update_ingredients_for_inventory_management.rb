class UpdateIngredientsForInventoryManagement < ActiveRecord::Migration[7.1]
  def change
    change_table :ingredients do |t|
      # Remove unused columns
      t.remove :lb_per_bag, :containers, :on_order

      # Add new columns
      t.string :type_of_unit # Example: barrel, bag
      t.decimal :weight_per_unit, precision: 10, scale: 2
      t.decimal :total_weight, precision: 10, scale: 2
    end
  end
end
