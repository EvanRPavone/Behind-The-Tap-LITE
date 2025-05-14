class CreateTanks < ActiveRecord::Migration[7.1]
  def change
    create_table :tanks do |t|
      t.string :batch_no
      t.string :in_tank
      t.integer :status
      t.date :brew_date
      t.decimal :carbed_vol
      t.integer :next_steps_id
      t.integer :yeast_gen
      t.decimal :original_grav
      t.decimal :int_sg
      t.decimal :og_was
      t.decimal :og_is
      t.decimal :target_p
      t.decimal :ph
      t.decimal :current_sg
      t.integer :vessel_id
      t.decimal :est_abv
      t.decimal :target_abv
      t.date :d_rest_start
      t.date :crash_start
      t.date :target_release
      t.text :notes

      t.timestamps
    end
  end
end
