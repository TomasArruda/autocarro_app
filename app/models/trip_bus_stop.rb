class TripBusStop < ActiveRecord::Base
  belongs_to :trip
  belongs_to :bus_stop
end
