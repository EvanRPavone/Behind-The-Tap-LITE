class AddRecipeToKegs < ActiveRecord::Migration[7.1]
  def change
    add_reference :kegs, :recipe, foreign_key: true
  end
end
