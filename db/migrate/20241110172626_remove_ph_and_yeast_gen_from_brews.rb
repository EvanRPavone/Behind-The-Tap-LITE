class RemovePhAndYeastGenFromBrews < ActiveRecord::Migration[7.1]
  def change
    remove_column :brews, :ph, :decimal
    remove_column :brews, :yeast_gen, :integer
  end
end
