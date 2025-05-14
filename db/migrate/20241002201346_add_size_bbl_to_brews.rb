class AddSizeBblToBrews < ActiveRecord::Migration[7.1]
  def change
    add_column :brews, :size_bbl, :decimal, precision: 10, scale: 2
  end
end
