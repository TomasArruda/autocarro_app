class BusStopsController < ApplicationController
  before_action :set_bus_stop, only: [:show, :edit, :update, :destroy]

  def index
    @bus_stops = BusStop.all
  end

  def show
  end

  def new
    @bus_stop = BusStop.new
  end

  def create
    @bus_stop = BusStop.new(bus_stop_params)

    respond_to do |format|
      if @bus_stop.save
        format.html { redirect_to @bus_stop, notice: 'Bus stop was successfully created.' }
        format.json { render json: BusStop.all.order(:registration_number) }
      else
        format.html { render :new }
        format.json { render json: @bus_stop.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @bus_stop.update(bus_stop_params)
        format.html { redirect_to @bus_stop, notice: 'Bus stop was successfully updated.' }
        format.json { render json: BusStop.all.order(:identifier) }
      else
        format.html { render :edit }
        format.json { render json: @bus_stop.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @bus_stop.destroy
    respond_to do |format|
      format.html { redirect_to buses_url, notice: 'Bus stop was successfully destroyed.' }
    end
  end

  private

  def set_bus_stop
    @bus_stop = BusStop.find(params[:id])
  end

  def bus_stop_params
    params.require(:bus_stop).permit(:identifier)
  end
end
