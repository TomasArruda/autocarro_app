require 'rails_helper'

RSpec.describe BuildTrip, type: :model do
  context "create trip based on params" do
    let(:bus_stop1) { create(:bus_stop) }
    let(:bus_stop2) { create(:bus_stop) }
    let(:bus_stop3) { create(:bus_stop) }

    let(:params) do 
      {
        identifier: "3333", 
        bus_stops: [ bus_stop1.id.to_s, bus_stop2.id.to_s, bus_stop3.id.to_s ]
      }
    end

    let(:trip) { BuildTrip.call(params: params).trip }

    it "should build the trip properly" do
      expect(trip.identifier).to eq(params[:identifier])
      expect(trip.trip_bus_stop.length).to eq(params[:bus_stops].length)
    end

    it "should ad the bus stops in order" do
      expect(trip.trip_bus_stop[0].bus_stop_id.to_s).to eq(params[:bus_stops][0])
      expect(trip.trip_bus_stop[1].bus_stop_id.to_s).to eq(params[:bus_stops][1])
      expect(trip.trip_bus_stop[2].bus_stop_id.to_s).to eq(params[:bus_stops][2])
    end

    it "should create a valid trip" do
      expect(trip.valid?).to be true
    end
  end
end
