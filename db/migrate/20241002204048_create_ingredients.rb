class CreateIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.string :category
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :lb_per_bag, precision: 10, scale: 2
      t.boolean :on_order, default: false
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end

    # Create the join table for recipes and ingredients
    create_table :recipe_ingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
