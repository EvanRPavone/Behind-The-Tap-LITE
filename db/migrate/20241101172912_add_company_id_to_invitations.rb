class AddCompanyIdToInvitations < ActiveRecord::Migration[7.1]
  def change
    add_column :invitations, :company_id, :integer
  end
end
