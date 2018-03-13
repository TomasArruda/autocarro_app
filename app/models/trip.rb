class Trip < ApplicationRecord
  has_many :buses, :class_name => 'Bus', :foreign_key => 'bus_id'

  has_many :trip_bus_stop
  has_many :bus_stops, through: :trip_bus_stop

  validates :trip_bus_stop, length: { minimum: 2}

  def duration
    (0..(bus_stops.length - 2)).inject(0) do |duration, index|
      start_stop = bus_stops[index]
      end_stop = bus_stops[index+1]

      duration + duration_two_ways(start_stop, end_stop)
    end
  end

  private

  def duration_two_ways(start_stop, end_stop)
    connection_from_station = Connection.where(start_stop: start_stop, end_stop: end_stop).first
    connection_to_station = Connection.where(start_stop: end_stop, end_stop: start_stop).first
    connection_from_station.trip_duration + connection_to_station.trip_duration
  end
end
