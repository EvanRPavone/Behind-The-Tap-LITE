class AddPartnerCompaniesToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :partner_companies, :integer, array: true, default: []
  end
end
