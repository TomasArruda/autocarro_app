
class BuildTrip
  include Interactor

  before :setup

  def call
    context.trip = build_trip
  end

  private

  attr_accessor :params

  def build_trip
    trip = Trip.new(identifier: params[:identifier])
    bus_stops = params[:bus_stops].reject { |c| c.empty? }

    bus_stops.each do |bus_stop_id|
      trip.trip_bus_stop.build(bus_stop_id: bus_stop_id)
    end
    
    trip
  end

  def setup
    @params = context.params
  end
end