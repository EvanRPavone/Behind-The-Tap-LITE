class CreateMashLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :mash_logs do |t|
      t.references :brew, null: false, foreign_key: true
      t.datetime :mash_in_time
      t.datetime :mash_complete_time
      t.decimal :mash_temp
      t.decimal :mash_ph

      t.timestamps
    end
  end
end
