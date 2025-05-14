# db/migrate/xxxxxx_create_partnerships.rb
class CreatePartnerships < ActiveRecord::Migration[7.1]
  def change
    create_table :partnerships do |t|
      t.references :company, null: false, foreign_key: true
      t.references :partner, null: false, foreign_key: { to_table: :companies }

      t.timestamps
    end

    # Ensure no duplicate partnerships
    add_index :partnerships, [:company_id, :partner_id], unique: true
  end
end
