class AddSharedFromToKegs < ActiveRecord::Migration[7.1]
  def change
    add_column :kegs, :shared_from, :integer
    add_index :kegs, :shared_from
  end
end
