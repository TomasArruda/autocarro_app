require 'rails_helper'

RSpec.describe Trip, type: :model do
  context "with 3 bus stops" do
    let(:bus_stop1) { create(:bus_stop) }
    let(:bus_stop2) { create(:bus_stop) }
    let(:bus_stop3) { create(:bus_stop) }

    let!(:c1) { create(:connection, start_stop: bus_stop1, end_stop: bus_stop2) }
    let!(:c2) { create(:connection, start_stop: bus_stop2, end_stop: bus_stop3) }
    let!(:c3) { create(:connection, start_stop: bus_stop3, end_stop: bus_stop2) }
    let!(:c4) { create(:connection, start_stop: bus_stop2, end_stop: bus_stop1) }

    let(:trip) { build(:trip, bus_stops: [bus_stop1, bus_stop2, bus_stop3]) }

    let(:total_duration) { (c1.trip_duration + c2.trip_duration + c3.trip_duration + c4.trip_duration).minutes }
    let(:half_way_duration) { (c1.trip_duration + c2.trip_duration).minutes }

    it "should return the correct duration" do
      expect(trip.duration).to eq(total_duration)
    end

    it "should return the correct half_way_duration" do
      expect(trip.half_way_duration).to eq(half_way_duration)
    end

    it "should return the correct duration_and_resting and resting_time" do
      rest = (trip.duration/60) % 10
      resting_time = (10 - rest).minutes
      expect(trip.resting_time).to eq(resting_time)
      expect(trip.duration_and_resting).to eq(total_duration+resting_time)
    end
  end

  context "with only one bus_stop" do
    let(:bus_stop) { create(:bus_stop) }
    let(:trip) { build(:trip, bus_stops: [bus_stop]) }

    it "should be invalid" do
      expect(trip.valid?).to be false
    end
  end
end
