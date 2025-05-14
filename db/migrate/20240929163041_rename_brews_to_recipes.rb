class RenameBrewsToRecipes < ActiveRecord::Migration[7.1]
  def change
    rename_table :brews, :recipes
  end
end
