class GpsController < ApplicationController
  def index
    get_bus_stops_and_trips
  end
  
  def find_bus
    @bus_stop_origin = BusStop.find(params[:bus_stop_origin][:id])
    @bus_stop_destiny = BusStop.find(params[:bus_stop_destiny][:id])
    @trip = Trip.find(params[:trip][:id])

    bus_stops_ids = @trip.bus_stops.map(&:identifier)
    if bus_stops_ids.include?(@bus_stop_origin.identifier) || bus_stops_ids.include?(@bus_stop_destiny.identifier)
      @buses_position = CalculateBusesPosition.call(
        start_stop: @bus_stop_origin, 
        end_stop: @bus_stop_destiny, 
        trip: @trip,
      ).buses_position

      render :map
    else
      render :json => { :errors => "error" }
    end
  end

  def get_bus_stops_and_trips
    @bus_stops = BusStop.all
    @trips = Trip.all
  end
end
