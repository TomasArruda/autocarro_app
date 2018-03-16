class Bus < ApplicationRecord
  REGISTRATION_NUMBER_REGEX = /\A(^[A-Z]{2}[0-9]{2} [A-Z]{3}$)|(^[A-Z][0-9]{1,3} [A-Z]{3}$)|(^[A-Z]{3} [0-9]{1,3}[A-Z]$)|(^[0-9]{1,4} [A-Z]{1,2}$)|(^[0-9]{1,3} [A-Z]{1,3}$)|(^[A-Z]{1,2} [0-9]{1,4}$)|(^[A-Z]{1,3} [0-9]{1,3}$)\Z/i
  has_one :schedule, :class_name => "Schedule" 
  belongs_to :trip, :class_name => "Trip", :foreign_key => 'trip_id'

  validates :registration_number, presence: true, uniqueness: true, numericality: true
  validates_format_of :registration_number, :with => REGISTRATION_NUMBER_REGEX, :on => :create
end
