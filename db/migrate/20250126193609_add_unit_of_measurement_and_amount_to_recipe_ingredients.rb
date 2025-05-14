class AddUnitOfMeasurementAndAmountToRecipeIngredients < ActiveRecord::Migration[7.1]
  def change
    remove_column :recipe_ingredients, :unit
    add_column :recipe_ingredients, :unit_of_measurement, :string
  end
end
