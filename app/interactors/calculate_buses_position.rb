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
    buses_position[:buses] = buses.map{ |bus | calculate_bus_position(bus) }.compact     
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
    timetable = timetable(bus)
    schedules = JSON.parse(timetable["#{start_stop.id}"])
    next_schedule = find_next_schedule(schedules)

    if next_schedule
      bus_position = {}

      bus_position[:position] = find_bus_position(bus)
      bus_position[:distance] = time_difference_in_minutes(next_schedule, time)

      return bus_position
    else
      return nil
    end
  end

  def find_bus_position(bus)
    bus_stops_indexes = (1..(bus_stops.length - 1)).to_a
    bus_position = find_bus_position_on_timetable(
      bus.schedule.timetable_from_station,
      bus_stops.first, 
      bus_stops_indexes
    )
    return bus_position if bus_position
    
    reverted_bus_stops_indexes = (0..(bus_stops.length - 2)).to_a.reverse.to_a
    bus_position = find_bus_position_on_timetable(
      bus.schedule.timetable_to_station, 
      bus_stops.last, 
      reverted_bus_stops_indexes
    )
    return bus_position if bus_position

    return { start: bus_stops[0].identifier, next: bus_stops[0].identifier }
  end

  def find_bus_position_on_timetable(timetable, start_stop, indexes)
    indexes.each do |index|
      next_stop = bus_stops[index]

      position = mount_position_if_found(timetable, start_stop, next_stop)
      return position if position
      
      start_stop = bus_stops[index]
    end

    return nil
  end

  def mount_position_if_found(timetable, start_stop, next_stop)
    timetable_start = JSON.parse(timetable["#{start_stop.id}"])
    timetable_next = JSON.parse(timetable["#{next_stop.id}"])

    duration = connection_duration(start_stop, next_stop)

    (0..(timetable_next.length - 1)).to_a.each do |time_index|
      timetable_start_time = Time.parse(timetable_start[time_index])
      timetable_next_time = Time.parse(timetable_next[time_index])

      if timetable_start_time == time
        return { start: start_stop.identifier, next: start_stop.identifier }
      elsif timetable_next_time == time 
        return { start: next_stop.identifier, next: next_stop.identifier }
      elsif timetable_start_time < time && timetable_next_time > time
        return { start: start_stop.identifier, next: next_stop.identifier }
      end
    end

    return nil
  end


  def find_next_schedule(schedules)
    schedules.each do |schedule|
      schedule_time = Time.parse(schedule)
      if time < schedule_time
        return schedule_time
      end
    end

    return nil
  end

  def depart_time(bus)
    Time.parse(JSON.parse(bus.schedule.timetable_from_station.values.first).first)
  end

  def finish_time(bus)
    Time.parse(JSON.parse(bus.schedule.timetable_to_station.values.last).last)
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
    ((time1 - time2)/60).ceil
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
    @time = Time.parse(Time.now.strftime('%H:%M'))

    @connections = FetchConnections.call(bus_stops: trip.bus_stops).connections
  end
end