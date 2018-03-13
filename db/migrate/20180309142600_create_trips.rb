class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips do |t|
      t.string :identifier

      t.timestamps
    end
  end
end
