require 'rails_helper'

RSpec.describe BuildConnections, type: :model do
  context "create trip and bus stops to generate connections" do
    let(:bus_stop1) { create(:bus_stop) }
    let(:bus_stop2) { create(:bus_stop) }
    let(:bus_stop3) { create(:bus_stop) }

    let(:trip) { build(:trip, bus_stops: [bus_stop1, bus_stop2, bus_stop3]) }

    before do 
      BuildConnections.call(bus_stops: trip.bus_stops)
    end

    it "should create connections" do
      amount = Connection.count
      expect(amount).to eq(trip.bus_stops.length + 1)
    end

    it "should connect all bus stops" do
      connections1 = Connection.where(start_stop: bus_stop1)
      connections2 = Connection.where(start_stop: bus_stop2)
      connections3 = Connection.where(start_stop: bus_stop3)

      expect(connections1.first.end_stop).to eq(bus_stop2)
      expect(connections2.first.end_stop).to eq(bus_stop1)
      expect(connections2.last.end_stop).to eq(bus_stop3)
      expect(connections3.first.end_stop).to eq(bus_stop2)
    end
  end
end
