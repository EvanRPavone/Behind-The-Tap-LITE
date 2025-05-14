class CreateBoilLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :boil_logs do |t|
      t.references :brew, null: false, foreign_key: true
      t.datetime :vorlauf_start_time
      t.datetime :vorlauf_complete_time
      t.datetime :sparge_start_time
      t.decimal :sparge_amount
      t.datetime :sparge_complete_time
      t.datetime :kettle_full_time
      t.decimal :preboil_volume
      t.decimal :preboil_gravity
      t.decimal :preboil_ph
      t.datetime :boil_achieved_time
      t.datetime :boil_complete_time
      t.decimal :post_boil_amount
      t.decimal :post_boil_gravity
      t.decimal :post_boil_ph

      t.timestamps
    end
  end
end
