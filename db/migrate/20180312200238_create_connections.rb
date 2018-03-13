class CreateConnections < ActiveRecord::Migration[5.1]
  def change
    create_table :connections do |t|
      t.integer :trip_duration
      t.references :start_stop
      t.references :end_stop

      t.timestamps
    end
  end
end
