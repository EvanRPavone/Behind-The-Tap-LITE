class RenameTanksToBrewsAgain < ActiveRecord::Migration[7.1]
  def change
    rename_table :tanks, :brews
  end
end
