class CalculateBusesPosition
  include Interactor

  before :setup

  def call 
    context.buses_position = calculate_buses_position
  end

  private

  attr_accessor :start_stop, :end_stop, :trip, :buses, :bus_stops, :time, :connections

  def calculate_buses_position
    buses_position = {
      bus_stops: bus_stops.map(&:identifier)
    }
    buses_position[:buses] = buses.map{ |bus | calculate_bus_position(bus) }      
    buses_position[:connections] = connections_to_hash
    buses_position
  end

  def connections_to_hash
    connections.map do |connection|
      {
        start: connection.start_stop.identifier,
        next: connection.end_stop.identifier,
        duration: connection.trip_duration
      }
    end
  end

  def calculate_bus_position(bus)
    if time >= depart_time(bus) && time <= finish_time(bus)
      bus_position = {}
    
      timetable = timetable(bus)
      schedules = JSON.parse(timetable["#{start_stop.id}"])

      bus_position[:position] = find_bus_position_from_station(bus)
      bus_position[:distance] = time_difference_in_minutes(find_next_schedule(schedules), time)

      return bus_position
    else
      return nil
    end
  end

  def find_bus_position_from_station(bus)
    timetable = bus.schedule.timetable_from_station

    start_stop = bus_stops[0]

    (1..(bus_stops.length - 1)).to_a.each do |index|
      next_stop = bus_stops[index]

      timetable_start = JSON.parse(timetable["#{start_stop.id}"])
      timetable_next = JSON.parse(timetable["#{next_stop.id}"])

      duration = connection_duration(start_stop, next_stop)

      (0..(timetable_next.length - 1)).to_a.each do |time_index|
        timetable_start_time = normalize_time(timetable_start[time_index])
        timetable_next_time = normalize_time(timetable_next[time_index])

        if timetable_start_time == time
          return { start: start_stop.identifier, next: start_stop.identifier }
        elsif timetable_next_time == time 
          return { start: start_stop.identifier, next: start_stop.identifier }
        elsif timetable_start_time < time && timetable_next_time > time
          return { start: start_stop.identifier, next: next_stop.identifier }
        end
      end

      start_stop = bus_stops[index]
    end

    timetable = bus.schedule.timetable_to_station

    (0..(bus_stops.length - 2)).to_a.reverse.to_a.each do |index|
      next_stop = bus_stops[index]

      timetable_start = JSON.parse(timetable["#{start_stop.id}"])
      timetable_next = JSON.parse(timetable["#{next_stop.id}"])

      duration = connection_duration(start_stop, next_stop)

      (0..(timetable_next.length - 1)).to_a.each do |time_index|
        timetable_start_time = normalize_time(timetable_start[time_index])
        timetable_next_time = normalize_time(timetable_next[time_index])

        if timetable_start_time == time
          return { start: start_stop.identifier, next: start_stop.identifier }
        elsif timetable_next_time == time 
          return { start: start_stop.identifier, next: start_stop.identifier }
        elsif timetable_start_time < time && timetable_next_time > time
          return { start: start_stop.identifier, next: next_stop.identifier }
        end
      end

      start_stop = bus_stops[index]
    end
  end

  def find_next_schedule(schedules)
    schedules.each do |schedule|
      schedule_time = normalize_time(schedule)
      if time < schedule_time
        return schedule_time
      end
    end
  end

  def depart_time(bus)
    normalize_time(JSON.parse(bus.schedule.timetable_from_station.values.first).first)
  end

  def finish_time(bus)
    normalize_time(JSON.parse(bus.schedule.timetable_to_station.values.last).last)
  end

  def is_going_from_station?
    bus_stops.each do |bus_stop|
      return true if bus_stop == start_stop
      return false if bus_stop == end_stop
    end
  end

  def timetable(bus)
    return bus.schedule.timetable_from_station if is_going_from_station?
    return bus.schedule.timetable_to_station
  end

  def time_difference_in_minutes(time1, time2)
    ((time1 - time2)/60).ceil.minutes
  end

  def normalize_time(time)
    Time.parse(time)
  end

  def connection_duration(start_stop, next_stop)
    connections.select do |connection| 
      connection.start_stop.id == start_stop.id && connection.end_stop.id == next_stop.id
    end.first.trip_duration.minutes
  end

  def setup
    @start_stop = context.start_stop
    @end_stop = context.end_stop
    @trip = context.trip
    @buses = trip.buses
    @bus_stops = trip.bus_stops
    @time = normalize_time(Time.now.strftime('%H:%M'))

    @connections = FetchConnections.call(bus_stops: trip.bus_stops).connections
  end
end