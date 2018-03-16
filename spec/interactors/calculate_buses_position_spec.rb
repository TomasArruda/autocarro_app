require 'rails_helper'

RSpec.describe CalculateBusesPosition, type: :model do
  before { Timecop.freeze(Time.parse("10:00")) }
  after { Timecop.return }

  context "create trip with 3 bus stops and 1 bus" do
    let(:bus_stop1) { create(:bus_stop) }
    let(:bus_stop2) { create(:bus_stop) }
    let(:bus_stop3) { create(:bus_stop) }

    let(:bus_stops_identifiers) { trip.bus_stops.map(&:identifier) }

    let(:bus) { create(:bus) }

    let(:trip) { create(:trip, bus_stops: [bus_stop1, bus_stop2, bus_stop3], buses: [bus]) }
    let(:connections) { FetchConnections.call(bus_stops: trip.bus_stops).connections }

    let(:buses_position) { 
      CalculateBusesPosition.call(
        start_stop: bus_stop1, 
        end_stop: bus_stop3, 
        trip: trip,
      ).buses_position
    }

    before do
      BuildConnections.call(bus_stops: trip.bus_stops)
      BuildSchedules.call(trip: trip)

      bus.schedule = trip.schedules.first
      bus.save!
    end
    
    it "should create the hash properly" do
      expect(buses_position.keys).to include(:bus_stops)
      expect(buses_position.keys).to include(:buses)
      expect(buses_position.keys).to include(:connections)
    end

    it "should set bus_stops corretly" do
      expect(buses_position[:bus_stops][0]).to eq(bus_stop1.identifier)
      expect(buses_position[:bus_stops][1]).to eq(bus_stop2.identifier)
      expect(buses_position[:bus_stops][2]).to eq(bus_stop3.identifier)
    end

    it "should set bus corretly" do
      expect(bus_stops_identifiers).to include(buses_position[:buses].first[:position][:start])
      expect(bus_stops_identifiers).to include(buses_position[:buses].first[:position][:next])
    end

    it "should set connections corretly" do
      (0..(buses_position[:connections].length - 1)).each do |index|
        expect(buses_position[:connections][index][:start]).to eq(Connection.all[index].start_stop.identifier)
        expect(buses_position[:connections][index][:next]).to eq(Connection.all[index].end_stop.identifier)
        expect(buses_position[:connections][index][:duration]).to eq(Connection.all[index].trip_duration)
      end
    end
  end
end
