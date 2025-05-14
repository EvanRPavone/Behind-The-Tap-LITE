class UpdateIngredientsAgain < ActiveRecord::Migration[7.1]
  def change
    change_table :ingredients do |t|
      # Remove unused columns
      t.remove :unit_of_measurement
    end
  end
end
