class AddUnitToRecipeIngredients < ActiveRecord::Migration[7.1]
  def change
    add_column :recipe_ingredients, :unit, :string, default: 'lbs'  # Default to 'lbs'
  end
end
