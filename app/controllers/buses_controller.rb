class BusesController < ApplicationController
  before_action :set_bus, only: [:show, :edit, :update, :destroy]
  before_action :authorize_can_can

  def index
    @buses = Bus.all
  end

  def show
  end

  def new
    new_setup
  end

  def create
    new_setup
    @bus = Bus.new(registration_number: bus_params[:registration_number])

    @bus.trip = Trip.find(bus_params[:trip])
    @bus.schedule = Schedule.find(bus_params[:schedule])

    respond_to do |format|
      save_bus(format, 'Bus was successfully created.')
    end
  end

  def edit
    edit_setup
  end

  def update
    edit_setup
    @bus.registration_number = bus_params[:registration_number]
    @bus.trip = Trip.find(bus_params[:trip])
    @bus.schedule = Schedule.find(bus_params[:schedule])

    respond_to do |format|
      save_bus(format, 'Bus was successfully updated.')
    end
  end

  def destroy
    @bus.destroy
    
    redirect_to buses_path
  end

  private

  def save_bus(format, message)
    if @bus.save      
      format.html { redirect_to action: "index" }
      format.json { render json: Bus.all.order(:registration_number) }
    else
      format.html { render :edit }
      format.json { render json: @bus.errors, status: :unprocessable_entity }
    end
  end

  def set_bus
    @bus = Bus.find(params[:id])
  end

  def new_setup
    @bus = Bus.new
    get_trips
    build_trips_schedules

    @trip_id = "null"
    @schedule_id = "null"
  end

  def edit_setup
    get_trips
    build_trips_schedules

    @trip_id = @bus.trip.try(:id)
    @schedule_id = @bus.schedule.try(:id)
  end

  def get_trips
    @trips = Trip.all
  end

  def build_trips_schedules
    @trips_schedules = {}
    @trips.each do |trip|
      @trips_schedules[:"#{trip.id}"] = trip.schedules
    end
  end

  def bus_params
    params.require(:bus).permit(:registration_number, :trip, :schedule)
  end

  def authorize_can_can
    authorize! :mana, :all
  end
end
