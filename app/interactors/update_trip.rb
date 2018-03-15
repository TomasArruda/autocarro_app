class UpdateTrip
  include Interactor

  before :setup

  def call
    update_trip
  end

  private

  attr_accessor :trip, :params

  def update_trip
    trip.update(identifier: params[:identifier])
    bus_stops = params[:bus_stops].reject { |c| c.empty? }

    trip.trip_bus_stop.clear if bus_stops.any?

    bus_stops.each do |bus_stop_id|
      trip.trip_bus_stop.build(bus_stop_id: bus_stop_id)
    end
  end

  def setup
    @trip = context.trip
    @params = context.params
  end
end