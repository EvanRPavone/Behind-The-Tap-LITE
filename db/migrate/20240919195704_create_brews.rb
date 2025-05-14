class CreateBrews < ActiveRecord::Migration[6.1]
  def change
    create_table :brews do |t|
      t.string :name
      t.decimal :target_abv, precision: 5, scale: 2
      t.decimal :size_bbl, precision: 10, scale: 2
      t.integer :no_halves
      t.integer :no_sixtels
      t.integer :no_cases_can
      t.integer :no_twelve_can
      t.integer :tap_no
      t.text :ingredients, array: true, default: []
      t.date :brew_date
      t.date :keg_pkg_date
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
