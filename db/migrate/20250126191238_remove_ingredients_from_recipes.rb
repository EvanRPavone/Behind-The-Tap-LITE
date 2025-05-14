class RemoveIngredientsFromRecipes < ActiveRecord::Migration[7.1]
  def change
    remove_column :recipes, :ingredients, :text, array: true, default: []
  end

end
