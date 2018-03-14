class BusStop < ApplicationRecord
  has_many :trip_bus_stop
  has_many :trips, through: :trip_bus_stop
  has_many :connections, :class_name => 'Connection', :foreign_key => 'connection_id'
  
  validates :identifier, presence: true, uniqueness: true
  validates_numericality_of :identifier
end
