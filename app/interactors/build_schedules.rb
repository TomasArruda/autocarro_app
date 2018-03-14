
class BuildSchedules
  include Interactor

  before :setup

  def call
    build_schedules
  end

  private

  attr_accessor :trip, :duration_and_resting, :connections

  def build_schedules
    departs = depart_schedules
    finishes = finish_schedules

    (0..(number_of_buses - 1)).each do |index|
      Schedule.new(
        trip: trip, 
        start_time: departs[index], 
        end_time: finishes[index],
        timetable_from_station: build_timetable_from_station(departs[index], finishes[index]),
        timetable_to_station: build_timetable_to_station(departs[index], finishes[index]),
        bus_interval: Trip::MINIMUM_BUS_INTERVAL
      ).save
    end
  end

  def depart_schedules
    schedules = []

    next_time = Trip::TRIPS_START_TIME;
    schedules << Trip::TRIPS_START_TIME

    number_of_buses.times do 
      next_time = next_time + Trip::MINIMUM_BUS_INTERVAL.minutes
      schedules << next_time
    end

    schedules
  end

  def finish_schedules
    schedules = []

    bus_finish = Trip::TRIPS_FINISH_TIME - (number_of_buses * Trip::MINIMUM_BUS_INTERVAL.minutes)
    schedules << bus_finish

    number_of_buses.times do 
      bus_finish = (bus_finish + Trip::MINIMUM_BUS_INTERVAL.minutes) - resting_time.minutes
      schedules << bus_finish
    end

    schedules
  end

  def build_timetable_from_station(depart, finishes)
    timetable = {}
    schedules_from_station(depart).each do |bus_stop_depart|
      timetable[:"#{bus_stop_depart[:bus_stop].id}"] = full_bus_stop_schedule(bus_stop_depart[:depart], finishes)
    end
    timetable
  end

  def build_timetable_to_station(depart, finishes)
    timetable = {}
    schedules_to_station(depart).each do |bus_stop_depart|
      timetable[:"#{bus_stop_depart[:bus_stop].id}"] = full_bus_stop_schedule(bus_stop_depart[:depart], finishes)
    end
    timetable
  end

  def schedules_from_station(depart)
    bus_stops = trip.bus_stops
    bus_stop_departs = [{ bus_stop: bus_stops.first, depart: depart }]
    (0..(bus_stops.length - 2)).to_a.each do |index|
      start_stop = bus_stops[index]
      next_stop = bus_stops[index+1]
      duration = connection_duration(start_stop, next_stop)
      depart = depart + duration
      
      bus_stop_departs << { bus_stop: next_stop, depart: depart }
    end
    bus_stop_departs
  end

  def schedules_to_station(depart)
    bus_stops = trip.bus_stops
    depart = depart + trip.half_way_duration
    bus_stop_departs = [{ bus_stop: bus_stops.last, depart: depart }]
    (1..(bus_stops.length - 1)).to_a.reverse.to_a.each do |index|
      start_stop = bus_stops[index]
      next_stop = bus_stops[index-1]
      duration = connection_duration(start_stop, next_stop)
      depart = depart + duration

      bus_stop_departs << { bus_stop: next_stop, depart: depart }
    end
    bus_stop_departs
  end

  def full_bus_stop_schedule(depart, finishes)
    schedules = []
    while depart <= finishes do
      schedules << depart.strftime('%H:%M')
      depart = depart + duration_and_resting
    end
    schedules
  end

  def connection_duration(start_stop, next_stop)
    connections.select do |connection| 
      connection.start_stop.id == start_stop.id && connection.end_stop.id == next_stop.id
    end.first.trip_duration.minutes
  end

  def number_of_buses
    ((trip.duration/60) / Trip::MINIMUM_BUS_INTERVAL.to_f).ceil
  end

  def resting_time
    rest = (trip.duration/60) % 10
    10 - rest
  end

  def setup
    @trip = context.trip
    @duration_and_resting = trip.duration_and_resting
    @connections = FetchConnections.call(bus_stops: trip.bus_stops).connections
  end
end