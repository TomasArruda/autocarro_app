FactoryBot.define do
  factory :bus_stop do 
    id { Random.new.rand(1000..9999) }
    identifier  { Random.new.rand(1000..9999) }
  end
end