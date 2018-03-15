FactoryBot.define do
  factory :trip_bus_stop do 
    id { Random.new.rand(1000..9999) }
    trip  { build(:trip) }
    bus_stops { build(:bus_stop) }
  end
end