require 'rails_helper'

RSpec.describe BusStop, type: :model do
  context "create two bus stops with the same identifier" do
    let(:bus_stop1) { build(:bus_stop, identifier: 10) }
    let(:bus_stop2) { build(:bus_stop, identifier: 10) }

    it "should save bus_stop1 and make bus_stop2 invalid" do
      expect(bus_stop1.save).to be true
      expect(bus_stop2.valid?).to be false
    end
  end
end
