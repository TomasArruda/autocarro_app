class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.references :bus, foreign_key: true
      t.references :trip, foreign_key: true
      t.time :start_time
      t.time :end_time
      t.integer :bus_interval

      t.timestamps
    end
  end
end
