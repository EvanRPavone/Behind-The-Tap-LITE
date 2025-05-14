class ChangeDRestAndCrashStartToDatetime < ActiveRecord::Migration[7.1]
  def change
    change_column :brews, :d_rest_start, :datetime
    change_column :brews, :crash_start, :datetime
  end
end
