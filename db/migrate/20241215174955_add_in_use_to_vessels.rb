class AddInUseToVessels < ActiveRecord::Migration[7.1]
  def change
    add_column :vessels, :in_use, :boolean, default: false, null: false
  end
end
