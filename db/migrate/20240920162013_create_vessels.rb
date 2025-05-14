class CreateVessels < ActiveRecord::Migration[7.1]
  def change
    create_table :vessels do |t|
      t.string :name
      t.decimal :size_bbl, precision: 10, scale: 2  # This ensures precision for size in barrels

      t.timestamps
    end
  end
end
