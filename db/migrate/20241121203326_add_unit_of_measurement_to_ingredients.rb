class AddUnitOfMeasurementToIngredients < ActiveRecord::Migration[7.1]
  def change
    add_column :ingredients, :unit_of_measurement, :string
  end
end
