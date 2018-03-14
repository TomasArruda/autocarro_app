
class FetchConnections
  include Interactor

  before :setup

  def call
    context.connections = fetch_connections
  end

  private

  attr_accessor :bus_stops

  def fetch_connections
    connections = [];
    (0..(bus_stops.length - 2)).each do |index|
      start_stop = bus_stops[index]
      end_stop = bus_stops[index + 1]
      
      connections << Connection.where(start_stop: start_stop, end_stop: end_stop).first
      connections << Connection.where(start_stop: end_stop, end_stop: start_stop).first
    end
    connections
  end

  def setup
    @bus_stops = context.bus_stops
  end
end