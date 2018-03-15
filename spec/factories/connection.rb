FactoryBot.define do
  factory :connection do 
    id { Random.new.rand(1000..9999) }
    trip_duration  { Random.new.rand(1..10) }
    start_stop { build(:bus_stop) }
    end_stop { build(:bus_stop) }
  end
end