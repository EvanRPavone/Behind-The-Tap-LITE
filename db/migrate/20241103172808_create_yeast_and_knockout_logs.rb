class CreateYeastAndKnockoutLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :yeast_and_knockout_logs do |t|
      t.references :brew, null: false, foreign_key: true
      t.datetime :whirlpool_start_time
      t.datetime :knockout_start_time
      t.datetime :knockout_end_time
      t.decimal :trub_volume
      t.string :yeast_source
      t.string :yeast_id
      t.integer :yeast_generation

      t.timestamps
    end
  end
end
