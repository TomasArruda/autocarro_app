FactoryBot.define do
  factory :bus do 
    id { Random.new.rand(1000..9999) }
    registration_number  { "WE#{Random.new.rand(10..99)} ERT" }
    trip { |a| a.association(:trip) } 
  end
end