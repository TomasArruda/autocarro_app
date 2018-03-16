class Trip < ApplicationRecord
  MINIMUM_BUS_INTERVAL = 10
  TRIPS_START_TIME = Time.parse("6:00")
  TRIPS_FINISH_TIME = Time.parse("22:00")

  has_many :schedules, :class_name => 'Schedule'
  has_many :buses, :class_name => 'Bus'
  has_many :trip_bus_stop
  has_many :bus_stops, through: :trip_bus_stop

  validates :identifier, presence: true, uniqueness: true, numericality: true
  validates :trip_bus_stop, length: { minimum: 2, maximum: 10 }

  def duration
    (0..(bus_stops.length - 2)).inject(0) do |sum_duration, index|
      start_stop = bus_stops[index]
      end_stop = bus_stops[index+1]

      sum_duration + duration_two_ways(start_stop, end_stop)
    end
  end

  def half_way_duration
    (0..(bus_stops.length - 2)).inject(0) do |sum_duration, index|
      start_stop = bus_stops[index]
      end_stop = bus_stops[index+1]
      
      connection = Connection.where(start_stop: start_stop, end_stop: end_stop).first
      sum_duration + connection.trip_duration.minutes
    end
  end

  def duration_and_resting
    duration + resting_time
  end

  def resting_time
    rest = (duration/60) % 10
    (10 - rest).minutes
  end

  private

  def get_buses_schedule
    buses.map do |bus|
      bus.depart_time
    end
  end

  def duration_two_ways(start_stop, end_stop)
    connection_from_station = Connection.where(start_stop: start_stop, end_stop: end_stop).first
    connection_to_station = Connection.where(start_stop: end_stop, end_stop: start_stop).first
    raise "no_connection_found" unless connection_from_station && connection_from_station
    
    connection_from_station.trip_duration.minutes + connection_to_station.trip_duration.minutes
  end
end
