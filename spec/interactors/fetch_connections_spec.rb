require 'rails_helper'

RSpec.describe FetchConnections, type: :model do
  context "create trip with 3 bus stops and connections" do
    let(:bus_stop1) { create(:bus_stop) }
    let(:bus_stop2) { create(:bus_stop) }
    let(:bus_stop3) { create(:bus_stop) }

    let(:trip) { create(:trip, bus_stops: [bus_stop1, bus_stop2, bus_stop3]) }
    let(:connections) { FetchConnections.call(bus_stops: trip.bus_stops).connections }

    before do
      BuildConnections.call(bus_stops: trip.bus_stops)
    end
    
    it "should fetch all connections" do
      expect(connections.length).to eq(4)
    end

    it "should fetch connections corretly" do
      connections1 = connections.select.each { |connection| connection.start_stop == bus_stop1 }
      connections2 = connections.select.each { |connection| connection.start_stop == bus_stop2 }
      connections3 = connections.select.each { |connection| connection.start_stop == bus_stop3 }

      expect(connections1.first.end_stop).to eq(bus_stop2)
      expect(connections2.first.end_stop).to eq(bus_stop1)
      expect(connections2.last.end_stop).to eq(bus_stop3)
      expect(connections3.first.end_stop).to eq(bus_stop2)
    end
  end

  context "create trip with 3 bus stops and no connection" do
    let(:bus_stop1) { create(:bus_stop) }
    let(:bus_stop2) { create(:bus_stop) }
    let(:bus_stop3) { create(:bus_stop) }

    let(:trip) { create(:trip, bus_stops: [bus_stop1, bus_stop2, bus_stop3]) }
    let(:connections) { FetchConnections.call(bus_stops: trip.bus_stops).connections }

    it "should return no connection" do
      expect(connections).to be_empty
    end
  end
end
