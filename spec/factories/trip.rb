FactoryBot.define do
  factory :trip do 
    id { Random.new.rand(1000..9999) }
    identifier  { Random.new.rand(1000..9999) }
    bus_stops { [build(:bus_stop), build(:bus_stop)] }
  end
end