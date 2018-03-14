class Connection < ApplicationRecord
  belongs_to :start_stop, :class_name => "BusStop", :foreign_key => 'start_stop_id'
  belongs_to :end_stop, :class_name => "BusStop", :foreign_key => 'end_stop_id'

  validates :start_stop, uniqueness: { scope: :end_stop }
  validates :start_stop, presence: true
  validates :end_stop, presence: true
  validates :trip_duration, presence: true
end
