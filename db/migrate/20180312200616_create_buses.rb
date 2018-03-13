class CreateBuses < ActiveRecord::Migration[5.1]
  def change
    create_table :buses do |t|
      t.string :registration_number
      t.time :start_time
      t.time :end_time
      t.integer :trip_id, foreign_key: true

      t.timestamps
    end
  end
end
