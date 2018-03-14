
class BuildConnections
  include Interactor

  before :setup

  def call
    build_connections
  end

  private

  attr_accessor :bus_stops

  def build_connections
    (0..(bus_stops.length - 2)).each do |index|
      start_stop = bus_stops[index]
      end_stop = bus_stops[index + 1]

      create_two_ways_connection(start_stop, end_stop)
    end
  end

  def create_two_ways_connection(start_stop, end_stop)
    Connection.new(start_stop: start_stop, end_stop: end_stop, trip_duration: Random.new.rand(2..10)).save
    Connection.new(start_stop: end_stop, end_stop: start_stop, trip_duration: Random.new.rand(2..10)).save
  end

  def setup
    @bus_stops = context.bus_stops
  end
end