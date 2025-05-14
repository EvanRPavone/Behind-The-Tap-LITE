class CreateKegShares < ActiveRecord::Migration[7.1]
  def change
    create_table :keg_shares do |t|
      t.references :keg, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
