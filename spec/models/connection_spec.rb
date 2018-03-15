require 'rails_helper'

RSpec.describe Connection, type: :model do
  context "create two connections with the same start_stop and end_stop" do
    let(:bus_stop1) { create(:bus_stop) }
    let(:bus_stop2) { create(:bus_stop) }

    let(:c1) { build(:connection, start_stop: bus_stop1, end_stop: bus_stop2) }
    let(:c2) { build(:connection, start_stop: bus_stop1, end_stop: bus_stop2) }

    it "should should save c1 and make c2 invalid" do
      expect(c1.save).to be true
      expect(c2.valid?).to be false
    end
  end
end
