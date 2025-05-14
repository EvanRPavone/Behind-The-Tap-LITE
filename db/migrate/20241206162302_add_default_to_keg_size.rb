class AddDefaultToKegSize < ActiveRecord::Migration[7.1]
  def change
    change_column_default :kegs, :size, 0
  end
end
