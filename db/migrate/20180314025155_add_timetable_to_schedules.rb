class AddTimetableToSchedules < ActiveRecord::Migration[5.1]
  def change
    add_column :schedules, :timetable_from_station, :hstore, default: {}, null: false
    add_column :schedules, :timetable_to_station, :hstore, default: {}, null: false
  end
end
