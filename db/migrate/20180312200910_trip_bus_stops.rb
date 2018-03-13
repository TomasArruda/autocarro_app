class TripBusStops < ActiveRecord::Migration[5.1]
  def change
    create_table :trip_bus_stops do |t|
      t.references :trip, index: true, foreign_key: true
      t.references :bus_stop, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
