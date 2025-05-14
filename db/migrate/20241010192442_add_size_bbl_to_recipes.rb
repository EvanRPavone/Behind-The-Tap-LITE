class AddSizeBblToRecipes < ActiveRecord::Migration[7.1]
  def change
    # Remove size_bbl from brews table
    remove_column :brews, :size_bbl, :decimal, precision: 10, scale: 2

    # Add size_bbl to recipes table
    add_column :recipes, :size_bbl, :decimal, precision: 10, scale: 2
  end

end
