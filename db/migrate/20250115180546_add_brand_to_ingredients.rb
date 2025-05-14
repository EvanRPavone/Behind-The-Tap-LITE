class AddBrandToIngredients < ActiveRecord::Migration[7.1]
  def change
    add_column :ingredients, :brand, :string
  end
end
