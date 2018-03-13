
class BuildConnections
  include Interactor

  before :setup

  def call
    context.connections = build_connections;
  end

  private

  attr_accessor :bus_stops

  def build_connections
    (0..(bus_stops.length - 2)).each do |index|
      start_stop = bus_stops[index]
      end_stop = bus_stops[index + 1]

      if non_existing_connection(start_stop, end_stop)
        Connection.new(start_stop: start_stop, end_stop: end_stop, trip_duration: Random.new.rand(2..10)).save
        Connection.new(start_stop: end_stop, end_stop: start_stop, trip_duration: Random.new.rand(2..10)).save
      end
    end
  end

  def non_existing_connection(start_stop, end_stop)
    Connection.where(start_stop: start_stop, end_stop: end_stop).empty?
  end

  def setup
    @bus_stops = context.bus_stops
  end
end