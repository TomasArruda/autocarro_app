class CreateBusStops < ActiveRecord::Migration[5.1]
  def change
    create_table :bus_stops do |t|
      t.integer :identifier

      t.timestamps
    end
  end
end
