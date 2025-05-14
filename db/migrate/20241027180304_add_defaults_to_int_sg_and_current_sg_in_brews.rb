class AddDefaultsToIntSgAndCurrentSgInBrews < ActiveRecord::Migration[6.0]
  def change
    change_column_default :brews, :int_sg, 1.000
    change_column_default :brews, :current_sg, 1.000
  end
end
