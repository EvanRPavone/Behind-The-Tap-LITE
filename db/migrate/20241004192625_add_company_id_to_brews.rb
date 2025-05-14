class AddCompanyIdToBrews < ActiveRecord::Migration[7.1]
  def change
    add_column :brews, :company_id, :integer
    add_index :brews, :company_id
  end
end
