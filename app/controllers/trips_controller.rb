class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy]

  def index
    @trips = Trip.all
  end

  def show
  end

  def new
    @trip = Trip.new
    get_bus_stop
  end

  def create
    @trip = Trip.new(identifier: trip_params[:identifier])

    trip_params[:bus_stops].each do |bus_stop_id|
      unless bus_stop_id.empty?
        @trip.trip_bus_stop.build(bus_stop_id: bus_stop_id)
      end
    end

    respond_to do |format|
      if @trip.save
        BuildConnections.call(bus_stops: @trip.bus_stops)

        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
        format.json { render json: Trip.all.order(:registration_number) }
      else
        format.html { render :new }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    get_bus_stop
  end

  def update
    respond_to do |format|
      if @trip.update(trip_params)
        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { render json: Trip.all.order(:registration_number) }
      else
        format.html { render :edit }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @bus.destroy
    respond_to do |format|
      format.html { redirect_to buses_url, notice: 'Trip was successfully destroyed.' }
    end
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def get_bus_stop
    @bus_stops = BusStop.all
    @trip_bus_stop = @trip.trip_bus_stop.build
  end


  def trip_params
    params.require(:trip).permit(:identifier, :bus_stops => [])
  end
end
