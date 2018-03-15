require 'rails_helper'

RSpec.describe Bus, type: :model do
  context "create a bus with registration number invalid" do
    let(:bus) { build(:bus, registration_number: "x") }

    it "should be invalid" do
      expect(bus.valid?).to be false
    end
  end
end