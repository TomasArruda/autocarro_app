class BusesController < ApplicationController
  before_action :set_bus, only: [:show, :edit, :update, :destroy]

  def index
    @buses = Bus.all
  end

  def show
  end

  def new
    @bus = Bus.new
    get_trips
  end

  def create
    byebug
    @bus = Bus.new()
    @bus.registration_number = bus_params[:registration_number]
    @bus.trip = Trip.find(bus_params[:trip])

    respond_to do |format|
      if @bus.save
        format.html { redirect_to @bus, notice: 'Bus was successfully created.' }
        format.json { render json: Bus.all.order(:registration_number) }
      else
        format.html { render :new }
        format.json { render json: @bus.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    get_trips
  end

  def update
    respond_to do |format|
      if @bus.update(bus_params)
        format.html { redirect_to @bus, notice: 'Bus was successfully updated.' }
        format.json { render json: Bus.all.order(:registration_number) }
      else
        format.html { render :edit }
        format.json { render json: @bus.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @bus.destroy
    respond_to do |format|
      format.html { redirect_to buses_url, notice: 'Bus was successfully destroyed.' }
    end
  end

  private

  def set_bus
    @bus = Bus.find(params[:id])
  end

  def get_trips
    @trips = Trip.all
  end

  def bus_params
    params.require(:bus).permit(:registration_number, :trip)
  end
end
