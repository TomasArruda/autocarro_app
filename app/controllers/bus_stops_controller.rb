class BusStopsController < ApplicationController
  before_action :set_bus_stop, only: [:show, :edit, :update, :destroy]
  before_action :authorize_can_can

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
    @bus_stop.trip_bus_stop.destroy_all
    @bus_stop.destroy
    
    redirect_to bus_stops_path
  end

  private

  def save_bus_stop(format, message)
    if @bus_stop.save      
      format.html { redirect_to action: "index" }
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

  def authorize_can_can
    authorize! :mana, :all
  end
end
