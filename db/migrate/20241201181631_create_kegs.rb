class CreateKegs < ActiveRecord::Migration[7.1]
  def change
    create_table :kegs do |t|
      t.string :name
      t.decimal :size
      t.string :size_unit
      t.string :status
      t.references :brew, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
