class GpsController < ApplicationController
  def index
    get_bus_stops_and_trips
  end
  
  def find_bus
    begin
      @bus_stop_origin = BusStop.find(params[:bus_stop_origin][:id])
      @bus_stop_destiny = BusStop.find(params[:bus_stop_destiny][:id])
      @trip = Trip.find(params[:trip][:id])

      @bus_map = {
        origin: @bus_stop_origin.identifier,
        destily: @bus_stop_destiny.identifier
      }
      
      bus_stops_ids = @trip.bus_stops.map(&:identifier)
      if bus_stops_ids.include?(@bus_stop_origin.identifier) || bus_stops_ids.include?(@bus_stop_destiny.identifier)
        buses_position = CalculateBusesPosition.call(
          start_stop: @bus_stop_origin, 
          end_stop: @bus_stop_destiny, 
          trip: @trip,
        ).buses_position

        @bus_map[:buses_positions] = buses_position
        render :map
      else
        raise "bus_stops_id are not in the list"
      end
    rescue => e
      respond_to do |format|
        format.html { redirect_to action: "index" }
      end
    end
  end

  def get_bus_stops_and_trips
    @bus_stops = BusStop.all
    @trips = Trip.all
  end
end
