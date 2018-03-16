class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy]

  def index
    @trips = Trip.all
  end

  def show
  end

  def new
    @trip = Trip.new
    get_bus_stops
    @selected_bus_stops = []
  end

  def create
    byebug
    @selected_bus_stops = []
    @trip = BuildTrip.call(params: trip_params).trip
    
    respond_to do |format|
      save_trip(format, 'Trip was successfully created.')
    end
  end

  def edit
    get_bus_stops
    @selected_bus_stops = @trip.bus_stops
    selected_bus_stops_ids = @selected_bus_stops.map(&:id)
    @bus_stops = @bus_stops.select { |bs| !selected_bus_stops_ids.include?(bs.id) }
  end

  def update
    get_bus_stops
    @selected_bus_stops = @trip.bus_stops
    selected_bus_stops_ids = @selected_bus_stops.map(&:id)
    @bus_stops = @bus_stops.select { |bs| !selected_bus_stops_ids.include?(bs.id) }
    
    UpdateTrip.call(trip: @trip, params: trip_params)

    respond_to do |format|
      save_trip(format, 'Trip was successfully updated.')
    end
  end

  def destroy
    @bus.destroy
    respond_to do |format|
      format.html { redirect_to buses_url, notice: 'Trip was successfully destroyed.' }
    end
  end

  private

  def save_trip(format, message)
    if @trip.save
      BuildConnections.call(bus_stops: @trip.bus_stops)
      BuildSchedules.call(trip: @trip)
      
      format.html { redirect_to @trip, notice: message }
      format.json { render json: Trip.all.order(:identifier) }
    else
      format.html { render :edit }
      format.json { render json: @trip.errors, status: :unprocessable_entity }
    end
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def get_bus_stops
    @bus_stops = BusStop.all
    @trip_bus_stop = @trip.trip_bus_stop.build
  end

  def trip_params
    params.require(:trip).permit(:identifier, :bus_stops => [])
  end
end
