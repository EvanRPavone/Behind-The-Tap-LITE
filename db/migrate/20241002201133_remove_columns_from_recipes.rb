class RemoveColumnsFromRecipes < ActiveRecord::Migration[7.1]
  def change
    remove_column :recipes, :size_bbl, :decimal, precision: 10, scale: 2
    remove_column :recipes, :no_halves, :integer
    remove_column :recipes, :no_sixtels, :integer
    remove_column :recipes, :no_cases_can, :integer
    remove_column :recipes, :no_twelve_can, :integer
    remove_column :recipes, :tap_no, :integer
    remove_column :recipes, :brew_date, :date
    remove_column :recipes, :keg_pkg_date, :date
  end
end
