require 'rails_helper'

RSpec.describe BuildSchedules, type: :model do
  context "gengerate schedules without connections" do
    let(:bus_stop1) { create(:bus_stop) }
    let(:bus_stop2) { create(:bus_stop) }
    let(:bus_stop3) { create(:bus_stop) }

    let(:trip) { build(:trip, bus_stops: [bus_stop1, bus_stop2, bus_stop3]) }

    it "should raise an error" do
      expect{BuildSchedules.call(trip: trip)}.to raise_error("no_connection_found")
    end
  end

  context "gengerate schedules with connections" do
    let(:bus_stop1) { create(:bus_stop) }
    let(:bus_stop2) { create(:bus_stop) }
    let(:bus_stop3) { create(:bus_stop) }

    let(:trip) { build(:trip, bus_stops: [bus_stop1, bus_stop2, bus_stop3]) }

    before do
      BuildConnections.call(bus_stops: trip.bus_stops)
      BuildSchedules.call(trip: trip)
    end

    it "should create shcedules properly" do
      trip.schedules.each do |schedule|
        expect(schedule.trip).to eq(trip)
        expect(schedule.timetable_from_station.keys).to include(bus_stop1.id.to_s)
        expect(schedule.timetable_to_station.keys).to include(bus_stop1.id.to_s)
        expect(schedule.timetable_from_station.keys).to include(bus_stop2.id.to_s)
        expect(schedule.timetable_to_station.keys).to include(bus_stop2.id.to_s)
        expect(schedule.timetable_from_station.keys).to include(bus_stop3.id.to_s)
        expect(schedule.timetable_to_station.keys).to include(bus_stop3.id.to_s)
      end
    end
  end
end
