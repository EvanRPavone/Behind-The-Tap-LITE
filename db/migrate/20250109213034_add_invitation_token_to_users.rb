class AddInvitationTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :invitation_token, :string
  end
end
