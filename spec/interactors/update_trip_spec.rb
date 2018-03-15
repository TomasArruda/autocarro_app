require 'rails_helper'

RSpec.describe UpdateTrip, type: :model do
  context "create trip based on params" do
    let(:bus_stop1) { create(:bus_stop) }
    let(:bus_stop2) { create(:bus_stop) }
    let(:bus_stop3) { create(:bus_stop) }

    let(:trip_id) { 1111 }
    let(:trip) { create(:trip, identifier: trip_id, bus_stops: [bus_stop1, bus_stop2, bus_stop3]) }

    let(:params) do 
      {
        identifier: "3333", 
        bus_stops: [bus_stop2.id.to_s, bus_stop3.id.to_s]
      }
    end

    it "should update the identifier" do
      expect(trip.identifier).to eq(trip_id.to_s)

      UpdateTrip.call(trip: trip, params: params)

      expect(trip.identifier.to_s).to eq(params[:identifier])
    end

    it "should update the trip bus stop relation" do
      expect(trip.trip_bus_stop.length).to eq(trip.bus_stops.length)
      expect(trip.trip_bus_stop[0].bus_stop_id).to eq(trip.bus_stops[0].id)
      expect(trip.trip_bus_stop[1].bus_stop_id).to eq(trip.bus_stops[1].id)
      expect(trip.trip_bus_stop[2].bus_stop_id).to eq(trip.bus_stops[2].id)

      UpdateTrip.call(trip: trip, params: params)

      expect(trip.trip_bus_stop.length).to eq(params[:bus_stops].length)
      expect(trip.trip_bus_stop[0].bus_stop_id.to_s).to eq(params[:bus_stops][0])
      expect(trip.trip_bus_stop[1].bus_stop_id.to_s).to eq(params[:bus_stops][1])
    end

    it "should still be a valid trip" do
      expect(trip.valid?).to be true

      UpdateTrip.call(trip: trip, params: params)

      expect(trip.valid?).to be true
    end
  end
end
