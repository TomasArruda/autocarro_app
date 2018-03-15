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
      save_bus_stop(format, 'Bus stop was successfully created.')
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      save_bus_stop(format, 'Bus stop was successfully updated.')
    end
  end

  def destroy
    @bus_stop.destroy
    respond_to do |format|
      format.html { redirect_to buses_url, notice: 'Bus stop was successfully destroyed.' }
    end
  end

  private

  def save_bus_stop(format, message)
    if @bus_stop.save      
      format.html { redirect_to @bus_stop, notice: message }
      format.json { render json: BusStop.all.order(:identifier) }
    else
      format.html { render :edit }
      format.json { render json: @bus_stop.errors, status: :unprocessable_entity }
    end
  end

  def set_bus_stop
    @bus_stop = BusStop.find(params[:id])
  end

  def bus_stop_params
    params.require(:bus_stop).permit(:identifier)
  end
end
