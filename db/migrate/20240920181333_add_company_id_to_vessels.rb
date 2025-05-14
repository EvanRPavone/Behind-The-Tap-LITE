class AddCompanyIdToVessels < ActiveRecord::Migration[7.1]
  def change
    add_column :vessels, :company_id, :integer
  end
end
